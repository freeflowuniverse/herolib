
# TUS (1.0.0) — Server-Side Specs (Concise)

## Always

* All requests/responses **except** `OPTIONS` MUST include: `Tus-Resumable: 1.0.0`.
  If unsupported → `412 Precondition Failed` + `Tus-Version`.
* Canonical server features via `OPTIONS /files`:

  * `Tus-Version: 1.0.0`
  * `Tus-Extension: creation,creation-with-upload,termination,checksum,concatenation,concatenation-unfinished` (as supported)
  * `Tus-Max-Size: <int>` (if hard limit)
  * `Tus-Checksum-Algorithm: sha1[,md5,crc32...]` (if checksum ext.)

## Core

* **Create:** `POST /files` with `Upload-Length: <int>` OR `Upload-Defer-Length: 1`. Optional `Upload-Metadata`.

  * `201 Created` + `Location: /files/{id}`, echo `Tus-Resumable`.
  * *Creation-With-Upload:* If body present → `Content-Type: application/offset+octet-stream`, accept bytes, respond with `Upload-Offset`.
* **Status:** `HEAD /files/{id}`

  * Always return `Upload-Offset` for partial uploads, include `Upload-Length` if known; if deferred, return `Upload-Defer-Length: 1`. `Cache-Control: no-store`.
* **Upload:** `PATCH /files/{id}`

  * `Content-Type: application/offset+octet-stream` and `Upload-Offset` (must match server).
  * On success → `204 No Content` + new `Upload-Offset`.
  * Mismatch → `409 Conflict`. Bad type → `415 Unsupported Media Type`.
* **Terminate:** `DELETE /files/{id}` (if supported) → `204 No Content`. Subsequent requests → `404/410`.

## Checksum (optional but implemented here)

* Client MAY send: `Upload-Checksum: <algo> <base64digest>` per `PATCH`.

  * Server MUST verify request body’s checksum of the exact received bytes.
  * If algo unsupported → `400 Bad Request`.
  * If mismatch → **discard the chunk** (no offset change) and respond `460 Checksum Mismatch`.
  * If OK → `204 No Content` + new `Upload-Offset`.
* `OPTIONS` MUST include `Tus-Checksum-Algorithm` (comma-separated algos).

## Concatenation (optional but implemented here)

* **Partial uploads:** `POST /files` with `Upload-Concat: partial` and `Upload-Length`. (MUST have length; may use creation-with-upload/patch thereafter.)
* **Final upload:** `POST /files` with
  `Upload-Concat: final; /files/{a} /files/{b} ...`

  * MUST NOT include `Upload-Length`.
  * Final uploads **cannot** be `PATCH`ed (`403`).
  * Server SHOULD assemble final (in order).
  * If `concatenation-unfinished` supported, final may be created before partials completed; server completes once all partials are done.
* **HEAD semantics:**

  * For *partial*: MUST include `Upload-Offset`.
  * For *final* before concatenation: SHOULD NOT include `Upload-Offset`. `Upload-Length` MAY be present if computable (= sum of partials’ lengths when known).
  * After finalization: `Upload-Offset == Upload-Length`.

---

# TUS FastAPI Server (disk-only, crash-safe, checksum + concatenation)

**Features**

* All persistent state on disk:

  ```
  TUS_ROOT/
    {upload_id}/
      info.json         # canonical metadata & status
      data.part         # exists while uploading or while building final
      data              # final file after atomic rename
  ```
* Crash recovery: `HEAD` offset = size of `data.part` or `data`.
* `.part` during upload; `os.replace()` (atomic) to `data` on completion.
* Streaming I/O; `fsync` on file + parent directory.
* Checksum: supports `sha1` (can easily add md5/crc32).
* Concatenation: server builds final when partials complete; supports `concatenation-unfinished`.

> Run with: `uv pip install fastapi uvicorn` then `uvicorn tus_server:app --host 0.0.0.0 --port 8080` (or `python tus_server.py`).
> Set `TUS_ROOT` env to choose storage root.

```python
# tus_server.py
from fastapi import FastAPI, Request, Response, HTTPException
from typing import Optional, Dict, Any, List
import os, json, uuid, base64, asyncio, errno, hashlib

# -----------------------------
# Config
# -----------------------------
TUS_VERSION = "1.0.0"
# Advertise extensions implemented below:
TUS_EXTENSIONS = ",".join([
    "creation",
    "creation-with-upload",
    "termination",
    "checksum",
    "concatenation",
    "concatenation-unfinished",
])
# Supported checksum algorithms (keys = header token)
CHECKSUM_ALGOS = ["sha1"]  # add "md5" if desired

TUS_ROOT = os.environ.get("TUS_ROOT", "/tmp/tus")
MAX_SIZE = 1 << 40  # 1 TiB default

os.makedirs(TUS_ROOT, exist_ok=True)
app = FastAPI()

# Per-process locks to prevent concurrent mutations on same upload_id
_locks: Dict[str, asyncio.Lock] = {}
def _lock_for(upload_id: str) -> asyncio.Lock:
    if upload_id not in _locks:
        _locks[upload_id] = asyncio.Lock()
    return _locks[upload_id]

# -----------------------------
# Path helpers
# -----------------------------
def upload_dir(upload_id: str) -> str:
    return os.path.join(TUS_ROOT, upload_id)

def info_path(upload_id: str) -> str:
    return os.path.join(upload_dir(upload_id), "info.json")

def part_path(upload_id: str) -> str:
    return os.path.join(upload_dir(upload_id), "data.part")

def final_path(upload_id: str) -> str:
    return os.path.join(upload_dir(upload_id), "data")

# -----------------------------
# FS utils (crash-safe)
# -----------------------------
def _fsync_dir(path: str) -> None:
    fd = os.open(path, os.O_DIRECTORY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)

def _write_json_atomic(path: str, obj: Dict[str, Any]) -> None:
    tmp = f"{path}.tmp"
    data = json.dumps(obj, separators=(",", ":"), ensure_ascii=False)
    with open(tmp, "w", encoding="utf-8") as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, path)
    _fsync_dir(os.path.dirname(path))

def _read_json(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def _size(path: str) -> int:
    try:
        return os.path.getsize(path)
    except FileNotFoundError:
        return 0

def _exists(path: str) -> bool:
    return os.path.exists(path)

# -----------------------------
# TUS helpers
# -----------------------------
def _ensure_tus_version(req: Request):
    if req.method == "OPTIONS":
        return
    v = req.headers.get("Tus-Resumable")
    if v is None:
        raise HTTPException(status_code=412, detail="Missing Tus-Resumable")
    if v != TUS_VERSION:
        raise HTTPException(status_code=412, detail="Unsupported Tus-Resumable",
                            headers={"Tus-Version": TUS_VERSION})

def _parse_metadata(raw: Optional[str]) -> str:
    # Raw passthrough; validate/consume in your app if needed.
    return raw or ""

def _new_upload_info(upload_id: str,
                     kind: str,  # "single" | "partial" | "final"
                     length: Optional[int],
                     defer_length: bool,
                     metadata: str,
                     parts: Optional[List[str]] = None) -> Dict[str, Any]:
    return {
        "upload_id": upload_id,
        "kind": kind,  # "single" (default), "partial", or "final"
        "length": length,               # int or None if deferred/unknown
        "defer_length": bool(defer_length),
        "metadata": metadata,           # raw Upload-Metadata header
        "completed": False,
        "parts": parts or [],           # for final: list of upload_ids (not URLs)
    }

def _load_info_or_404(upload_id: str) -> Dict[str, Any]:
    p = info_path(upload_id)
    if not _exists(p):
        raise HTTPException(404, "Upload not found")
    try:
        return _read_json(p)
    except Exception as e:
        raise HTTPException(500, f"Corrupt metadata: {e}")

def _set_info(upload_id: str, info: Dict[str, Any]) -> None:
    _write_json_atomic(info_path(upload_id), info)

def _ensure_dir(path: str):
    os.makedirs(path, exist_ok=False)

def _atomic_finalize_file(upload_id: str):
    """Rename data.part → data and mark completed."""
    upath = upload_dir(upload_id)
    p = part_path(upload_id)
    f = final_path(upload_id)
    if _exists(p):
        with open(p, "rb+") as fp:
            fp.flush()
            os.fsync(fp.fileno())
        os.replace(p, f)
        _fsync_dir(upath)
    info = _load_info_or_404(upload_id)
    info["completed"] = True
    _set_info(upload_id, info)

def _current_offsets(upload_id: str):
    f, p = final_path(upload_id), part_path(upload_id)
    if _exists(f):
        return True, False, _size(f)
    if _exists(p):
        return False, True, _size(p)
    return False, False, 0

def _parse_concat_header(h: Optional[str]) -> Optional[Dict[str, Any]]:
    if not h:
        return None
    h = h.strip()
    if h == "partial":
        return {"type": "partial", "parts": []}
    if h.startswith("final;"):
        # format: final;/files/a /files/b
        rest = h[len("final;"):].strip()
        urls = [s for s in rest.split(" ") if s]
        return {"type": "final", "parts": urls}
    return None

def _extract_upload_id_from_url(url: str) -> str:
    # Accept relative /files/{id} (common) — robust split:
    segs = [s for s in url.split("/") if s]
    return segs[-1] if segs else url

def _sum_lengths_or_none(ids: List[str]) -> Optional[int]:
    total = 0
    for pid in ids:
        info = _load_info_or_404(pid)
        if info.get("length") is None:
            return None
        total += int(info["length"])
    return total

async def _stream_with_checksum_and_append(file_obj, request: Request, algo: Optional[str]) -> int:
    """Stream request body to file, verifying checksum if header present.
       Returns bytes written. On checksum mismatch, truncate to original size and raise HTTPException(460)."""
    start_pos = file_obj.tell()
    # Choose hash
    hasher = None
    provided_digest = None
    if algo:
        if algo not in CHECKSUM_ALGOS:
            raise HTTPException(400, "Unsupported checksum algorithm")
        if algo == "sha1":
            hasher = hashlib.sha1()
        # elif algo == "md5": hasher = hashlib.md5()
        # elif algo == "crc32": ... (custom)
    # Read expected checksum
    if hasher:
        uh = request.headers.get("Upload-Checksum")
        if not uh:
            # spec: checksum header optional; if algo passed to this fn we must have parsed it already
            pass
        else:
            try:
                name, b64 = uh.split(" ", 1)
                if name != algo:
                    raise ValueError()
                provided_digest = base64.b64decode(b64.encode("ascii"))
            except Exception:
                raise HTTPException(400, "Invalid Upload-Checksum")
    written = 0
    async for chunk in request.stream():
        if not chunk:
            continue
        file_obj.write(chunk)
        if hasher:
            hasher.update(chunk)
        written += len(chunk)
    # Verify checksum if present
    if hasher and provided_digest is not None:
        digest = hasher.digest()
        if digest != provided_digest:
            # rollback appended bytes
            file_obj.truncate(start_pos)
            file_obj.flush()
            os.fsync(file_obj.fileno())
            raise HTTPException(status_code=460, detail="Checksum Mismatch")
    file_obj.flush()
    os.fsync(file_obj.fileno())
    return written

def _try_finalize_final(upload_id: str):
    """If this is a final upload and all partials are completed, build final data and finalize atomically."""
    info = _load_info_or_404(upload_id)
    if info.get("kind") != "final" or info.get("completed"):
        return
    part_ids = info.get("parts", [])
    # Check all partials completed and have data
    for pid in part_ids:
        pinf = _load_info_or_404(pid)
        if not pinf.get("completed"):
            return  # still not ready
        if not _exists(final_path(pid)):
            # tolerate leftover .part (e.g., if completed used .part->data). If data missing, can't finalize.
            return
    # Build final .part by concatenating parts' data in order, then atomically rename
    up = upload_dir(upload_id)
    os.makedirs(up, exist_ok=True)
    ppath = part_path(upload_id)
    # Reset/overwrite .part
    with open(ppath, "wb") as out:
        for pid in part_ids:
            with open(final_path(pid), "rb") as src:
                for chunk in iter(lambda: src.read(1024 * 1024), b""):
                    out.write(chunk)
        out.flush()
        os.fsync(out.fileno())
    # If server can compute length now, set it
    length = _sum_lengths_or_none(part_ids)
    info["length"] = length if length is not None else info.get("length")
    _set_info(upload_id, info)
    _atomic_finalize_file(upload_id)

# -----------------------------
# Routes
# -----------------------------
@app.options("/files")
async def tus_options():
    headers = {
        "Tus-Version": TUS_VERSION,
        "Tus-Extension": TUS_EXTENSIONS,
        "Tus-Max-Size": str(MAX_SIZE),
        "Tus-Checksum-Algorithm": ",".join(CHECKSUM_ALGOS),
    }
    return Response(status_code=204, headers=headers)

@app.post("/files")
async def tus_create(request: Request):
    _ensure_tus_version(request)

    metadata = _parse_metadata(request.headers.get("Upload-Metadata"))
    concat = _parse_concat_header(request.headers.get("Upload-Concat"))

    # Validate creation modes
    hdr_len = request.headers.get("Upload-Length")
    hdr_defer = request.headers.get("Upload-Defer-Length")

    if concat and concat["type"] == "partial":
        # Partial MUST have Upload-Length (spec)
        if hdr_len is None:
            raise HTTPException(400, "Partial uploads require Upload-Length")
        if hdr_defer is not None:
            raise HTTPException(400, "Partial uploads cannot defer length")
    elif concat and concat["type"] == "final":
        # Final MUST NOT include Upload-Length
        if hdr_len is not None or hdr_defer is not None:
            raise HTTPException(400, "Final uploads must not include Upload-Length or Upload-Defer-Length")
    else:
        # Normal single upload: require length or defer
        if hdr_len is None and hdr_defer != "1":
            raise HTTPException(400, "Must provide Upload-Length or Upload-Defer-Length: 1")

    # Parse length
    length: Optional[int] = None
    defer = False
    if hdr_len is not None:
        try:
            length = int(hdr_len)
            if length < 0: raise ValueError()
        except ValueError:
            raise HTTPException(400, "Invalid Upload-Length")
        if length > MAX_SIZE:
            raise HTTPException(413, "Upload too large")
    elif not concat or concat["type"] != "final":
        # final has no length at creation
        defer = (hdr_defer == "1")

    upload_id = str(uuid.uuid4())
    udir = upload_dir(upload_id)
    _ensure_dir(udir)

    if concat and concat["type"] == "final":
        # Resolve part ids from URLs
        part_ids = [_extract_upload_id_from_url(u) for u in concat["parts"]]
        # Compute length if possible
        sum_len = _sum_lengths_or_none(part_ids)
        info = _new_upload_info(upload_id, "final", sum_len, False, metadata, part_ids)
        _set_info(upload_id, info)

        # Prepare empty .part (will be filled when partials complete)
        with open(part_path(upload_id), "wb") as f:
            f.flush(); os.fsync(f.fileno())
        _fsync_dir(udir)

        # If all partials already complete, finalize immediately
        _try_finalize_final(upload_id)

        return Response(status_code=201,
                        headers={"Location": f"/files/{upload_id}",
                                 "Tus-Resumable": TUS_VERSION})

    # Create partial or single
    kind = "partial" if (concat and concat["type"] == "partial") else "single"
    info = _new_upload_info(upload_id, kind, length, defer, metadata)
    _set_info(upload_id, info)

    # Create empty .part
    with open(part_path(upload_id), "wb") as f:
        f.flush(); os.fsync(f.fileno())
    _fsync_dir(udir)

    # Creation-With-Upload (optional body)
    upload_offset = 0
    has_body = request.headers.get("Content-Length") or request.headers.get("Transfer-Encoding")
    if has_body:
        ctype = request.headers.get("Content-Type", "")
        if ctype != "application/offset+octet-stream":
            raise HTTPException(415, "Content-Type must be application/offset+octet-stream for creation-with-upload")
        # Checksum header optional; if present, parse algo token
        uh = request.headers.get("Upload-Checksum")
        algo = None
        if uh:
            try:
                algo = uh.split(" ", 1)[0]
            except Exception:
                raise HTTPException(400, "Invalid Upload-Checksum")

        async with _lock_for(upload_id):
            with open(part_path(upload_id), "ab+") as f:
                f.seek(0, os.SEEK_END)
                upload_offset = await _stream_with_checksum_and_append(f, request, algo)

        # If length known and we hit it, finalize
        inf = _load_info_or_404(upload_id)
        if inf["length"] is not None and upload_offset == int(inf["length"]):
            _atomic_finalize_file(upload_id)
            # If this is a partial that belongs to some final, a watcher could finalize final; here we rely on
            # client to create final explicitly (spec). Finalization of final is handled by _try_finalize_final
            # when final resource is created (or rechecked on subsequent HEAD/PATCH).
    headers = {"Location": f"/files/{upload_id}", "Tus-Resumable": TUS_VERSION}
    if upload_offset:
        headers["Upload-Offset"] = str(upload_offset)
    return Response(status_code=201, headers=headers)

@app.head("/files/{upload_id}")
async def tus_head(upload_id: str, request: Request):
    _ensure_tus_version(request)
    info = _load_info_or_404(upload_id)
    is_final = info.get("kind") == "final"

    headers = {
        "Tus-Resumable": TUS_VERSION,
        "Cache-Control": "no-store",
    }
    if info.get("metadata"):
        headers["Upload-Metadata"] = info["metadata"]

    if info.get("length") is not None:
        headers["Upload-Length"] = str(int(info["length"]))
    elif info.get("defer_length"):
        headers["Upload-Defer-Length"] = "1"

    exists_final, exists_part, offset = False, False, 0
    if is_final and not info.get("completed"):
        # BEFORE concatenation completes: SHOULD NOT include Upload-Offset
        # Try to see if we can finalize now (e.g., partials completed after crash)
        _try_finalize_final(upload_id)
        info = _load_info_or_404(upload_id)
        if info.get("completed"):
            # fallthrough to completed case
            pass
        else:
            # For in-progress final, no Upload-Offset; include Upload-Length if computable (already handled above)
            return Response(status_code=200, headers=headers)

    # For partials or completed finals
    f = final_path(upload_id)
    p = part_path(upload_id)
    if _exists(f):
        exists_final, offset = True, _size(f)
    elif _exists(p):
        exists_part, offset = True, _size(p)
    else:
        # if info exists but no data, consider gone
        raise HTTPException(410, "Upload gone")

    headers["Upload-Offset"] = str(offset)
    return Response(status_code=200, headers=headers)

@app.patch("/files/{upload_id}")
async def tus_patch(upload_id: str, request: Request):
    _ensure_tus_version(request)
    info = _load_info_or_404(upload_id)

    if info.get("kind") == "final":
        raise HTTPException(403, "Final uploads cannot be patched")

    ctype = request.headers.get("Content-Type", "")
    if ctype != "application/offset+octet-stream":
        raise HTTPException(415, "Content-Type must be application/offset+octet-stream")

    # Client offset must match server
    try:
        client_offset = int(request.headers.get("Upload-Offset", "-1"))
        if client_offset < 0: raise ValueError()
    except ValueError:
        raise HTTPException(400, "Invalid or missing Upload-Offset")

    # If length deferred, client may now set Upload-Length (once)
    if info.get("length") is None and info.get("defer_length"):
        if "Upload-Length" in request.headers:
            try:
                new_len = int(request.headers["Upload-Length"])
                if new_len < 0:
                    raise ValueError()
            except ValueError:
                raise HTTPException(400, "Invalid Upload-Length")
            if new_len > MAX_SIZE:
                raise HTTPException(413, "Upload too large")
            info["length"] = new_len
            info["defer_length"] = False
            _set_info(upload_id, info)

    # Determine current server offset
    f = final_path(upload_id)
    p = part_path(upload_id)
    if _exists(f):
        raise HTTPException(403, "Upload already finalized")
    if not _exists(p):
        raise HTTPException(404, "Upload not found")

    server_offset = _size(p)
    if client_offset != server_offset:
        return Response(status_code=409)

    # Optional checksum
    uh = request.headers.get("Upload-Checksum")
    algo = None
    if uh:
        try:
            algo = uh.split(" ", 1)[0]
        except Exception:
            raise HTTPException(400, "Invalid Upload-Checksum")

    # Append data (with rollback on checksum mismatch)
    async with _lock_for(upload_id):
        with open(p, "ab+") as fobj:
            fobj.seek(0, os.SEEK_END)
            written = await _stream_with_checksum_and_append(fobj, request, algo)

    new_offset = server_offset + written

    # If length known and reached exactly, finalize
    info = _load_info_or_404(upload_id)  # reload
    if info.get("length") is not None and new_offset == int(info["length"]):
        _atomic_finalize_file(upload_id)

    # If this is a partial, a corresponding final may exist and be now completable
    # We don't maintain reverse index; finalization is triggered when HEAD on final is called.
    # (Optional: scan for finals to proactively finalize.)

    return Response(status_code=204, headers={"Tus-Resumable": TUS_VERSION, "Upload-Offset": str(new_offset)})

@app.delete("/files/{upload_id}")
async def tus_delete(upload_id: str, request: Request):
    _ensure_tus_version(request)
    async with _lock_for(upload_id):
        udir = upload_dir(upload_id)
        for p in (part_path(upload_id), final_path(upload_id), info_path(upload_id)):
            try:
                os.remove(p)
            except FileNotFoundError:
                pass
        try:
            os.rmdir(udir)
        except OSError:
            pass
    return Response(status_code=204, headers={"Tus-Resumable": TUS_VERSION})
```

---

## Quick Client Examples (manual)

```bash
# OPTIONS
curl -i -X OPTIONS http://localhost:8080/files

# 1) Single upload (known length)
curl -i -X POST http://localhost:8080/files \
  -H "Tus-Resumable: 1.0.0" \
  -H "Upload-Length: 11" \
  -H "Upload-Metadata: filename Zm9vLnR4dA=="
# → Location: /files/<ID>

# Upload with checksum (sha1 of "hello ")
printf "hello " | curl -i -X PATCH http://localhost:8080/files/<ID> \
  -H "Tus-Resumable: 1.0.0" \
  -H "Content-Type: application/offset+octet-stream" \
  -H "Upload-Offset: 0" \
  -H "Upload-Checksum: sha1 L6v8xR3Lw4N2n9kQox3wL7G0m/I=" \
  --data-binary @-
# (Replace digest with correct base64 for your chunk)

# 2) Concatenation
# Create partial A (5 bytes)
curl -i -X POST http://localhost:8080/files \
  -H "Tus-Resumable: 1.0.0" \
  -H "Upload-Length: 5" \
  -H "Upload-Concat: partial"
# → Location: /files/<A>
printf "hello" | curl -i -X PATCH http://localhost:8080/files/<A> \
  -H "Tus-Resumable: 1.0.0" \
  -H "Content-Type: application/offset+octet-stream" \
  -H "Upload-Offset: 0" \
  --data-binary @-

# Create partial B (6 bytes)
curl -i -X POST http://localhost:8080/files \
  -H "Tus-Resumable: 1.0.0" \
  -H "Upload-Length: 6" \
  -H "Upload-Concat: partial"
# → Location: /files/<B>
printf " world" | curl -i -X PATCH http://localhost:8080/files/<B> \
  -H "Tus-Resumable: 1.0.0" \
  -H "Content-Type: application/offset+octet-stream" \
  -H "Upload-Offset: 0" \
  --data-binary @-

# Create final (may be before or after partials complete)
curl -i -X POST http://localhost:8080/files \
  -H "Tus-Resumable: 1.0.0" \
  -H "Upload-Concat: final; /files/<A> /files/<B>"
# HEAD on final will eventually show Upload-Offset once finalized
curl -i -X HEAD http://localhost:8080/files/<FINAL> -H "Tus-Resumable: 1.0.0"
```

---

## Implementation Notes (agent hints)

* **Durability:** every data write `fsync(file)`; after `os.replace` of `*.part → data` or `info.json.tmp → info.json`, also `fsync(parent)`.
* **Checksum:** verify against **this request’s** body only; on mismatch, **truncate back** to previous size and return `460`.
* **Concatenation:** final upload is never `PATCH`ed. Server builds `final.data.part` by concatenating each partial’s **final file** in order, then atomically renames and marks completed. It’s triggered lazily in `HEAD` of final (and right after creation).
* **Crash Recovery:** offset = `size(data.part)` or `size(data)`; `info.json` is canonical for `kind`, `length`, `defer_length`, `completed`, `parts`.
* **Multi-process deployments:** replace `asyncio.Lock` with file locks (`fcntl.flock`) per `upload_id` to synchronize across workers.



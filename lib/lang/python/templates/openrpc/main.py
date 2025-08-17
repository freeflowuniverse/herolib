#!/usr/bin/env python3
import os
import json
import signal
import asyncio
from typing import Union

import uvicorn
from fastapi import FastAPI, Response, WebSocket, WebSocketDisconnect
from jsonrpcobjects.objects import (
    ErrorResponse,
    Notification,
    ParamsNotification,
    ParamsRequest,
    Request,
    ResultResponse,
)
from openrpc import RPCServer

# ---------- FastAPI + OpenRPC ----------
app = FastAPI(title="Calculator JSON-RPC (HTTP + UDS)")
RequestType = Union[ParamsRequest, Request, ParamsNotification, Notification]
rpc = RPCServer(title="Calculator API", version="1.0.0")

# Calculator methods
@rpc.method()
async def add(a: float, b: float) -> float:
    return a + b

@rpc.method()
async def subtract(a: float, b: float) -> float:
    return a - b

@rpc.method()
async def multiply(a: float, b: float) -> float:
    return a * b

@rpc.method()
async def divide(a: float, b: float) -> float:
    if b == 0:
        # Keep it simple; library turns this into a JSON-RPC error
        raise ValueError("Division by zero")
    return a / b

# Expose the generated OpenRPC spec as REST (proxy to rpc.discover)
@app.get("/openrpc.json")
async def openrpc_json() -> Response:
    req = '{"jsonrpc":"2.0","id":1,"method":"rpc.discover"}'
    resp = await rpc.process_request_async(req)       # JSON string
    payload = json.loads(resp)                        # dict with "result"
    return Response(content=json.dumps(payload["result"]),
                    media_type="application/json")

# JSON-RPC over WebSocket
@app.websocket("/rpc")
async def ws_process_rpc(websocket: WebSocket) -> None:
    await websocket.accept()
    try:
        async def _process_rpc(request: str) -> None:
            json_rpc_response = await rpc.process_request_async(request)
            if json_rpc_response is not None:
                await websocket.send_text(json_rpc_response)

        while True:
            data = await websocket.receive_text()
            asyncio.create_task(_process_rpc(data))
    except WebSocketDisconnect:
        await websocket.close()

# JSON-RPC over HTTP POST
@app.post("/rpc", response_model=Union[ErrorResponse, ResultResponse, None])
async def http_process_rpc(request: RequestType) -> Response:
    json_rpc_response = await rpc.process_request_async(request.model_dump_json())
    return Response(content=json_rpc_response, media_type="application/json")


# ---------- Run BOTH: TCP:7766 and UDS:/tmp/server1 ----------
async def serve_both():
    uds_path = "/tmp/server1"

    # Clean stale socket path (if previous run crashed)
    try:
        if os.path.exists(uds_path) and not os.path.isfile(uds_path):
            os.unlink(uds_path)
    except FileNotFoundError:
        pass

    # Create two uvicorn servers sharing the same FastAPI app
    tcp_config = uvicorn.Config(app=app, host="127.0.0.1", port=7766, log_level="info")
    uds_config = uvicorn.Config(app=app, uds=uds_path, log_level="info")

    tcp_server = uvicorn.Server(tcp_config)
    uds_server = uvicorn.Server(uds_config)

    # We'll handle signals ourselves (avoid conflicts between two servers)
    tcp_server.install_signal_handlers = False
    uds_server.install_signal_handlers = False

    loop = asyncio.get_running_loop()
    def _graceful_shutdown():
        tcp_server.should_exit = True
        uds_server.should_exit = True

    for sig in (signal.SIGINT, signal.SIGTERM):
        try:
            loop.add_signal_handler(sig, _graceful_shutdown)
        except NotImplementedError:
            # e.g., on Windows; best-effort
            pass

    try:
        await asyncio.gather(
            tcp_server.serve(),
            uds_server.serve(),
        )
    finally:
        # Cleanup the socket file on exit
        try:
            if os.path.exists(uds_path) and not os.path.isfile(uds_path):
                os.unlink(uds_path)
        except Exception:
            pass


if __name__ == "__main__":
    asyncio.run(serve_both())

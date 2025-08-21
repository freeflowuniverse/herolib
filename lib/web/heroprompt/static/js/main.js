console.log('Heroprompt UI loaded');

let currentWs = localStorage.getItem('heroprompt-current-ws') || 'default';
let selected = [];

const el = (id) => document.getElementById(id);

async function api(url) {
    try { const r = await fetch(url); return await r.json(); }
    catch { return { error: 'request failed' }; }
}
async function post(url, data) {
    const form = new FormData();
    Object.entries(data).forEach(([k, v]) => form.append(k, v));
    try { const r = await fetch(url, { method: 'POST', body: form }); return await r.json(); }
    catch { return { error: 'request failed' }; }
}

// Checkbox-based collapsible tree
let nodeId = 0;

function renderTree(displayName, fullPath) {
    const c = document.createElement('div');
    c.className = 'tree';
    const ul = document.createElement('ul');
    ul.className = 'tree-root';
    const root = buildDirNode(displayName, fullPath, true);
    ul.appendChild(root);
    c.appendChild(ul);
    return c;
}

function buildDirNode(name, fullPath, expanded = false) {
    const li = document.createElement('li');
    li.className = 'dir';
    const id = `tn_${nodeId++}`;

    const toggle = document.createElement('input');
    toggle.type = 'checkbox';
    toggle.className = 'toggle';
    toggle.id = id;
    if (expanded) toggle.checked = true;

    const label = document.createElement('label');
    label.htmlFor = id;
    label.className = 'dir-label';
    const icon = document.createElement('span');
    icon.className = 'chev';
    const text = document.createElement('span');
    text.className = 'name';
    text.textContent = name;
    label.appendChild(icon);
    label.appendChild(text);

    const add = document.createElement('button');
    add.textContent = '+';
    add.title = 'Add directory to selection';
    add.onclick = () => addDirToSelection(fullPath);

    const children = document.createElement('ul');
    children.className = 'children';

    toggle.addEventListener('change', async () => {
        if (toggle.checked) {
            if (!li.dataset.loaded) {
                await loadChildren(fullPath, children);
                li.dataset.loaded = '1';
            }
        }
    });

    // Load immediately if expanded by default
    if (expanded) {
        setTimeout(async () => {
            await loadChildren(fullPath, children);
            li.dataset.loaded = '1';
        }, 0);
    }

    li.appendChild(toggle);
    li.appendChild(label);
    li.appendChild(add);
    li.appendChild(children);
    return li;
}

function createFileNode(name, fullPath) {
    const li = document.createElement('li');
    li.className = 'file';
    const a = document.createElement('a');
    a.href = '#';
    a.textContent = name;
    a.onclick = (e) => { e.preventDefault(); };
    const add = document.createElement('button');
    add.textContent = '+';
    add.title = 'Add file to selection';
    add.onclick = () => addFileToSelection(fullPath);
    li.appendChild(a);
    li.appendChild(add);
    return li;
}

async function loadChildren(parentPath, ul) {
    const r = await api(`/api/heroprompt/directory?name=${currentWs}&path=${encodeURIComponent(parentPath)}`);
    if (r.error) { ul.innerHTML = `<li class="err">${r.error}</li>`; return; }
    ul.innerHTML = '';
    for (const it of r.items) {
        const full = parentPath.endsWith('/') ? parentPath + it.name : parentPath + '/' + it.name;
        if (it.type === 'directory') {
            ul.appendChild(buildDirNode(it.name, full, false));
        } else {
            ul.appendChild(createFileNode(it.name, full));
        }
    }
}

async function loadDir(p) {
    el('tree').innerHTML = '';
    const display = p.split('/').filter(Boolean).slice(-1)[0] || p;
    el('tree').appendChild(renderTree(display, p));
    updateSelectionList();
}

function updateSelectionList() {
    el('selCount').textContent = String(selected.length);
    const ul = el('selected');
    ul.innerHTML = '';
    for (const p of selected) {
        const li = document.createElement('li');
        li.textContent = p;
        const btn = document.createElement('button');
        btn.textContent = 'remove';
        btn.onclick = () => { selected = selected.filter(x => x !== p); updateSelectionList(); };
        li.appendChild(btn);
        ul.appendChild(li);
    }
    // naive token estimator ~ 4 chars/token
    const tokens = Math.ceil(selected.join('\n').length / 4);
    el('tokenCount').textContent = String(Math.ceil(tokens));
}

function addToSelection(p) {
    if (!selected.includes(p)) { selected.push(p); updateSelectionList(); }
}


async function addDirToSelection(p) {
    const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/dirs`, { method: 'POST', body: new URLSearchParams({ path: p }) });
    const j = await r.json().catch(() => ({ error: 'request failed' }));
    if (j && j.ok !== false && !j.error) { if (!selected.includes(p)) selected.push(p); updateSelectionList(); }
}

async function addFileToSelection(p) {
    if (selected.includes(p)) return;
    const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/files`, { method: 'POST', body: new URLSearchParams({ path: p }) });
    const j = await r.json().catch(() => ({ error: 'request failed' }));
    if (j && j.ok !== false && !j.error) { selected.push(p); updateSelectionList(); }
}


// Theme persistence and toggle
(function initTheme() {
    const saved = localStorage.getItem('hero-theme');
    const root = document.documentElement;
    if (saved === 'light') root.classList.add('light');
})();

el('toggleTheme').onclick = () => {
    const root = document.documentElement;
    const isLight = root.classList.toggle('light');
    localStorage.setItem('hero-theme', isLight ? 'light' : 'dark');
};

// Workspaces list + selector
async function reloadWorkspaces() {
    const sel = document.getElementById('workspaceSelect');
    if (!sel) return;
    sel.innerHTML = '';
    const names = await api('/api/heroprompt/workspaces').catch(() => []);
    for (const n of names || []) {
        const opt = document.createElement('option');
        opt.value = n; opt.textContent = n;
        sel.appendChild(opt);
    }
    // ensure current ws name exists or select first
    function updateWsInfo(info) { const box = document.getElementById('wsInfo'); if (!box) return; if (!info || info.error) { box.textContent = ''; return; } box.textContent = `${info.name} — ${info.base_path}`; }

    if ([...sel.options].some(o => o.value === currentWs)) sel.value = currentWs;
    else if (sel.options.length > 0) sel.value = sel.options[0].value;
}
// On initial load: pick current or first workspace and load its base
(async function initWorkspace() {
    const sel = document.getElementById('workspaceSelect');
    const names = await api('/api/heroprompt/workspaces').catch(() => []);
    if (!names || names.length === 0) return;
    if (!currentWs || !names.includes(currentWs)) { currentWs = names[0]; localStorage.setItem('heroprompt-current-ws', currentWs); }
    if (sel) sel.value = currentWs;
    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
    const base = info?.base_path || '';
    if (base) await loadDir(base);
})();
// Create workspace modal wiring
const wcShow = () => { el('wcName').value = ''; el('wcPath').value = ''; el('wcError').textContent = ''; showModal('wsCreate'); };
el('wsCreateBtn')?.addEventListener('click', wcShow);
el('wcClose')?.addEventListener('click', () => hideModal('wsCreate'));
el('wcCancel')?.addEventListener('click', () => hideModal('wsCreate'));

el('wcCreate')?.addEventListener('click', async () => {
    const name = el('wcName').value.trim();
    const path = el('wcPath').value.trim();
    if (!path) { el('wcError').textContent = 'Path is required.'; return; }
    const formData = { base_path: path };
    if (name) formData.name = name;
    const resp = await post('/api/heroprompt/workspaces', formData);
    if (resp.error) { el('wcError').textContent = resp.error; return; }
    currentWs = resp.name || currentWs;
    localStorage.setItem('heroprompt-current-ws', currentWs);
    await reloadWorkspaces();
    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
    const base = info?.base_path || '';
    if (base) await loadDir(base);
    hideModal('wsCreate');
});
// Workspace details modal
el('wsDetailsBtn')?.addEventListener('click', async () => {
    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
    if (info && !info.error) { el('wdName').value = info.name || currentWs; el('wdPath').value = info.base_path || ''; el('wdError').textContent = ''; showModal('wsDetails'); }
});

el('wdClose')?.addEventListener('click', () => hideModal('wsDetails'));
el('wdCancel')?.addEventListener('click', () => hideModal('wsDetails'));

el('wdSave')?.addEventListener('click', async () => {
    const newName = el('wdName').value.trim();
    const newPath = el('wdPath').value.trim();
    // update via create semantics if name changed, or add an update endpoint later
    const form = new FormData(); if (newName) form.append('name', newName); if (newPath) form.append('base_path', newPath);
    const resp = await fetch('/api/heroprompt/workspaces', { method: 'POST', body: form });
    const j = await resp.json().catch(() => ({ error: 'request failed' }));
    if (j.error) { el('wdError').textContent = j.error; return; }
    currentWs = j.name || newName || currentWs; localStorage.setItem('heroprompt-current-ws', currentWs);
    await reloadWorkspaces();
    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
    const base = info?.base_path || '';
    if (base) await loadDir(base);
    hideModal('wsDetails');
});

el('wdDelete')?.addEventListener('click', async () => {
    // simple delete through factory delete via dedicated endpoint would be ideal; for now we can implement a delete endpoint later
    const ok = confirm('Delete this workspace?'); if (!ok) return;
    const r = await fetch(`/api/heroprompt/workspaces/${currentWs}`, { method: 'DELETE' });
    const j = await r.json().catch(() => ({}));
    // ignore errors for now
    await reloadWorkspaces();
    const sel = document.getElementById('workspaceSelect');
    currentWs = sel?.value || '';
    localStorage.setItem('heroprompt-current-ws', currentWs);
    if (currentWs) { const info = await api(`/api/heroprompt/workspaces/${currentWs}`); const base = info?.base_path || ''; if (base) await loadDir(base); }
    hideModal('wsDetails');
});




if (document.getElementById('workspaceSelect')) {
    // Copy Prompt: generate on server using workspace.prompt and copy to clipboard
    el('copyPrompt')?.addEventListener('click', async () => {
        const text = el('promptText')?.value || '';
        try {
            const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/prompt`, { method: 'POST', body: new URLSearchParams({ text }) });
            const out = await r.text();
            await navigator.clipboard.writeText(out);
        } catch (e) {
            console.warn('copy prompt failed', e);
        }
    });

    reloadWorkspaces();
    document.getElementById('workspaceSelect').addEventListener('change', async (e) => {
        currentWs = e.target.value;
        localStorage.setItem('heroprompt-current-ws', currentWs);
        const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
        const base = info?.base_path || '';
        if (base) await loadDir(base);
    });
}

document.getElementById('refreshWs')?.addEventListener('click', async () => {
    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
    const base = info?.base_path || '';
    if (base) await loadDir(base);
});
document.getElementById('openWsManage')?.addEventListener('click', async () => {
    // populate manage list and open
    const list = el('wmList'); const err = el('wmError'); if (!list) return;
    err.textContent = ''; list.innerHTML = '';
    const names = await api('/api/heroprompt/workspaces').catch(() => []);
    for (const n of names || []) { const li = document.createElement('li'); const s = document.createElement('span'); s.textContent = n; const b = document.createElement('button'); b.className = 'use'; b.textContent = 'Use'; b.onclick = async () => { currentWs = n; await reloadWorkspaces(); const info = await api(`/api/heroprompt/workspaces/${currentWs}`); const base = info?.base_path || ''; if (base) await loadDir(base); hideModal('wsManage'); }; li.appendChild(s); li.appendChild(b); list.appendChild(li); }
    showModal('wsManage');
});

// legacy setWs kept for backward compat - binds currentWs
el('setWs')?.addEventListener('click', async () => {
    const base = el('basePath')?.value?.trim();
    if (!base) { alert('Enter base path'); return; }
    const r = await post('/api/heroprompt/workspaces', { name: currentWs, base_path: base });
    if (r.error) { alert(r.error); return; }
    await loadDir(base);
});

el('doSearch').onclick = async () => {
    const q = el('search').value.trim();
    if (!q) return;
    const r = await api(`/api/heroprompt/search?name=${currentWs}&q=${encodeURIComponent(q)}`);
    if (r.error) { alert(r.error); return; }
    const tree = el('tree');
    tree.innerHTML = '<div>Search results:</div>';
    const ul = document.createElement('ul');
    for (const it of r) {
        const li = document.createElement('li');
        li.className = it.type;
        const a = document.createElement('a');
        a.href = '#'; a.textContent = it.path;
        a.onclick = async (e) => {
            e.preventDefault();
            if (it.type === 'file') {
                const rf = await api(`/api/heroprompt/file?name=${currentWs}&path=${encodeURIComponent(it.path)}`);
                if (!rf.error) el('preview').textContent = rf.content;
            } else {
                await loadDir(it.path);
            }
        };
        const add = document.createElement('button');
        add.textContent = '+';
        add.title = 'Add to selection';
        add.onclick = () => addToSelection(it.path);
        li.appendChild(a);
        li.appendChild(add);
        ul.appendChild(li);
    }
    tree.appendChild(ul);
};

// Tabs
function switchTab(id) {
    for (const t of document.querySelectorAll('.tab')) t.classList.remove('active');
    for (const p of document.querySelectorAll('.tab-pane')) p.classList.remove('active');
    const btn = document.querySelector(`.tab[data-tab="${id}"]`);
    const pane = document.getElementById(`tab-${id}`);
    if (btn && pane) {
        btn.classList.add('active');
        pane.classList.add('active');
    }
}

for (const btn of document.querySelectorAll('.tab')) {
    btn.addEventListener('click', () => switchTab(btn.dataset.tab));
}

// Chat (client-side mock for now)
el('sendChat').onclick = () => {
    const input = el('chatInput');
    const text = input.value.trim();
    if (!text) return;
    addChatMessage('user', text);
    input.value = '';
    // Mock AI response
    setTimeout(() => addChatMessage('ai', 'This is a placeholder AI response.'), 500);
};

function addChatMessage(role, text) {
    const msg = document.createElement('div');
    msg.className = `message ${role}`;
    const bubble = document.createElement('div');
    bubble.className = 'bubble';
    bubble.textContent = text;
    msg.appendChild(bubble);
    el('chatMessages').appendChild(msg);
    el('chatMessages').scrollTop = el('chatMessages').scrollHeight;
}

// Modal helpers
function showModal(id) { const m = el(id); if (!m) return; m.setAttribute('aria-hidden', 'false'); }
function hideModal(id) { const m = el(id); if (!m) return; m.setAttribute('aria-hidden', 'true'); el('wsError').textContent = ''; }







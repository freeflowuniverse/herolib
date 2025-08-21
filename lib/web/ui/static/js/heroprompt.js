console.log('Heroprompt UI loaded');

let currentWs = localStorage.getItem('heroprompt-current-ws') || 'default';
let selected = [];

const el = (id) => document.getElementById(id);

async function api(url) {
    try {
        const r = await fetch(url);
        if (!r.ok) {
            console.warn(`API call failed: ${url} - ${r.status}`);
            return { error: `HTTP ${r.status}` };
        }
        return await r.json();
    }
    catch (e) {
        console.warn(`API call error: ${url}`, e);
        return { error: 'request failed' };
    }
}

async function post(url, data) {
    const form = new FormData();
    Object.entries(data).forEach(([k, v]) => form.append(k, v));
    try {
        const r = await fetch(url, { method: 'POST', body: form });
        if (!r.ok) {
            console.warn(`POST failed: ${url} - ${r.status}`);
            return { error: `HTTP ${r.status}` };
        }
        return await r.json();
    }
    catch (e) {
        console.warn(`POST error: ${url}`, e);
        return { error: 'request failed' };
    }
}

// Bootstrap modal helpers
function showModal(id) {
    const modalEl = el(id);
    if (modalEl) {
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
    }
}

function hideModal(id) {
    const modalEl = el(id);
    if (modalEl) {
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
    }
}

// Tab switching with Bootstrap
function switchTab(tabName) {
    // Hide all tab panes
    document.querySelectorAll('.tab-pane').forEach(pane => {
        pane.style.display = 'none';
        pane.classList.remove('active');
    });

    // Remove active class from all tabs
    document.querySelectorAll('.tab').forEach(tab => {
        tab.classList.remove('active');
    });

    // Show selected tab pane
    const targetPane = el(`tab-${tabName}`);
    if (targetPane) {
        targetPane.style.display = 'block';
        targetPane.classList.add('active');
    }

    // Add active class to clicked tab
    const targetTab = document.querySelector(`.tab[data-tab="${tabName}"]`);
    if (targetTab) {
        targetTab.classList.add('active');
    }
}

// Initialize tab switching
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', function (e) {
            e.preventDefault();
            const tabName = this.getAttribute('data-tab');
            switchTab(tabName);
        });
    });
});

// Checkbox-based collapsible tree
let nodeId = 0;

function renderTree(displayName, fullPath) {
    const c = document.createElement('div');
    c.className = 'tree';
    const ul = document.createElement('ul');
    ul.className = 'tree-root list-unstyled';
    const root = buildDirNode(displayName, fullPath, true);
    ul.appendChild(root);
    c.appendChild(ul);
    return c;
}

function buildDirNode(name, fullPath, expanded = false) {
    const li = document.createElement('li');
    li.className = 'dir mb-1';
    const id = `tn_${nodeId++}`;

    const toggle = document.createElement('input');
    toggle.type = 'checkbox';
    toggle.className = 'toggle d-none';
    toggle.id = id;
    if (expanded) toggle.checked = true;

    const label = document.createElement('label');
    label.htmlFor = id;
    label.className = 'dir-label d-flex align-items-center text-decoration-none';
    label.style.cursor = 'pointer';

    const icon = document.createElement('span');
    icon.className = 'chev me-1';
    icon.innerHTML = expanded ? '📂' : '📁';

    const text = document.createElement('span');
    text.className = 'name flex-grow-1';
    text.textContent = name;

    label.appendChild(icon);
    label.appendChild(text);

    const add = document.createElement('button');
    add.className = 'btn btn-sm btn-outline-primary ms-1';
    add.textContent = '+';
    add.title = 'Add directory to selection';
    add.onclick = (e) => {
        e.stopPropagation();
        addDirToSelection(fullPath);
    };

    const children = document.createElement('ul');
    children.className = 'children list-unstyled ms-3';
    children.style.display = expanded ? 'block' : 'none';

    toggle.addEventListener('change', async () => {
        if (toggle.checked) {
            children.style.display = 'block';
            icon.innerHTML = '📂';
            if (!li.dataset.loaded) {
                await loadChildren(fullPath, children);
                li.dataset.loaded = '1';
            }
        } else {
            children.style.display = 'none';
            icon.innerHTML = '📁';
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
    li.className = 'file d-flex align-items-center mb-1';

    const icon = document.createElement('span');
    icon.className = 'me-2';
    icon.innerHTML = '📄';

    const a = document.createElement('a');
    a.href = '#';
    a.className = 'text-decoration-none flex-grow-1';
    a.textContent = name;
    a.onclick = (e) => {
        e.preventDefault();
        previewFile(fullPath);
    };

    const add = document.createElement('button');
    add.className = 'btn btn-sm btn-outline-primary ms-1';
    add.textContent = '+';
    add.title = 'Add file to selection';
    add.onclick = (e) => {
        e.stopPropagation();
        addFileToSelection(fullPath);
    };

    li.appendChild(icon);
    li.appendChild(a);
    li.appendChild(add);
    return li;
}

async function previewFile(filePath) {
    const previewEl = el('preview');
    if (!previewEl) return;

    previewEl.innerHTML = '<div class="loading">Loading...</div>';

    const r = await api(`/api/heroprompt/file?name=${currentWs}&path=${encodeURIComponent(filePath)}`);
    if (r.error) {
        previewEl.innerHTML = `<div class="error-message">Error: ${r.error}</div>`;
        return;
    }

    previewEl.textContent = r.content || 'No content';
}

async function loadChildren(parentPath, ul) {
    const r = await api(`/api/heroprompt/directory?name=${currentWs}&path=${encodeURIComponent(parentPath)}`);
    if (r.error) {
        ul.innerHTML = `<li class="text-danger small">${r.error}</li>`;
        return;
    }
    ul.innerHTML = '';
    for (const it of r.items || []) {
        const full = parentPath.endsWith('/') ? parentPath + it.name : parentPath + '/' + it.name;
        if (it.type === 'directory') {
            ul.appendChild(buildDirNode(it.name, full, false));
        } else {
            ul.appendChild(createFileNode(it.name, full));
        }
    }
}

async function loadDir(p) {
    const treeEl = el('tree');
    if (!treeEl) return;

    treeEl.innerHTML = '<div class="loading">Loading workspace...</div>';
    const display = p.split('/').filter(Boolean).slice(-1)[0] || p;
    treeEl.appendChild(renderTree(display, p));
    updateSelectionList();
}

function updateSelectionList() {
    const selCountEl = el('selCount');
    const tokenCountEl = el('tokenCount');
    const selectedEl = el('selected');

    if (selCountEl) selCountEl.textContent = String(selected.length);
    if (selectedEl) {
        selectedEl.innerHTML = '';
        if (selected.length === 0) {
            selectedEl.innerHTML = '<li class="text-muted small">No files selected</li>';
        } else {
            for (const p of selected) {
                const li = document.createElement('li');
                li.className = 'd-flex justify-content-between align-items-center mb-1 p-2 border rounded';

                const span = document.createElement('span');
                span.className = 'small';
                span.textContent = p;

                const btn = document.createElement('button');
                btn.className = 'btn btn-sm btn-outline-danger';
                btn.textContent = '×';
                btn.onclick = () => {
                    selected = selected.filter(x => x !== p);
                    updateSelectionList();
                };

                li.appendChild(span);
                li.appendChild(btn);
                selectedEl.appendChild(li);
            }
        }
    }

    // naive token estimator ~ 4 chars/token
    const tokens = Math.ceil(selected.join('\n').length / 4);
    if (tokenCountEl) tokenCountEl.textContent = String(Math.ceil(tokens));
}

function addToSelection(p) {
    if (!selected.includes(p)) {
        selected.push(p);
        updateSelectionList();
    }
}

async function addDirToSelection(p) {
    const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/dirs`, {
        method: 'POST',
        body: new URLSearchParams({ path: p })
    });
    const j = await r.json().catch(() => ({ error: 'request failed' }));
    if (j && j.ok !== false && !j.error) {
        if (!selected.includes(p)) selected.push(p);
        updateSelectionList();
    } else {
        console.warn('Failed to add directory:', j.error || 'Unknown error');
    }
}

async function addFileToSelection(p) {
    if (selected.includes(p)) return;
    const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/files`, {
        method: 'POST',
        body: new URLSearchParams({ path: p })
    });
    const j = await r.json().catch(() => ({ error: 'request failed' }));
    if (j && j.ok !== false && !j.error) {
        selected.push(p);
        updateSelectionList();
    } else {
        console.warn('Failed to add file:', j.error || 'Unknown error');
    }
}

// Workspaces list + selector
async function reloadWorkspaces() {
    const sel = el('workspaceSelect');
    if (!sel) return;

    sel.innerHTML = '<option>Loading...</option>';
    const names = await api('/api/heroprompt/workspaces');

    sel.innerHTML = '';
    if (names.error || !Array.isArray(names)) {
        sel.innerHTML = '<option>Error loading workspaces</option>';
        console.warn('Failed to load workspaces:', names);
        return;
    }

    for (const n of names) {
        const opt = document.createElement('option');
        opt.value = n;
        opt.textContent = n;
        sel.appendChild(opt);
    }

    // ensure current ws name exists or select first
    if (names.includes(currentWs)) {
        sel.value = currentWs;
    } else if (names.length > 0) {
        currentWs = names[0];
        sel.value = currentWs;
        localStorage.setItem('heroprompt-current-ws', currentWs);
    }
}

// On initial load: pick current or first workspace and load its base
async function initWorkspace() {
    const names = await api('/api/heroprompt/workspaces');
    if (names.error || !Array.isArray(names) || names.length === 0) {
        console.warn('No workspaces available');
        const treeEl = el('tree');
        if (treeEl) {
            treeEl.innerHTML = '<div class="text-muted small">No workspaces available. Create one to get started.</div>';
        }
        return;
    }

    if (!currentWs || !names.includes(currentWs)) {
        currentWs = names[0];
        localStorage.setItem('heroprompt-current-ws', currentWs);
    }

    const sel = el('workspaceSelect');
    if (sel) sel.value = currentWs;

    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
    const base = info?.base_path || '';
    if (base) await loadDir(base);
}

// Initialize everything when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    // Initialize workspaces
    initWorkspace();
    reloadWorkspaces();

    // Workspace selector change handler
    const workspaceSelect = el('workspaceSelect');
    if (workspaceSelect) {
        workspaceSelect.addEventListener('change', async (e) => {
            currentWs = e.target.value;
            localStorage.setItem('heroprompt-current-ws', currentWs);
            const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
            const base = info?.base_path || '';
            if (base) await loadDir(base);
        });
    }

    // Create workspace modal handlers
    const wsCreateBtn = el('wsCreateBtn');
    if (wsCreateBtn) {
        wsCreateBtn.addEventListener('click', () => {
            const nameEl = el('wcName');
            const pathEl = el('wcPath');
            const errorEl = el('wcError');

            if (nameEl) nameEl.value = '';
            if (pathEl) pathEl.value = '';
            if (errorEl) errorEl.textContent = '';

            showModal('wsCreate');
        });
    }

    const wcCreateBtn = el('wcCreate');
    if (wcCreateBtn) {
        wcCreateBtn.addEventListener('click', async () => {
            const name = el('wcName')?.value?.trim() || '';
            const path = el('wcPath')?.value?.trim() || '';
            const errorEl = el('wcError');

            if (!path) {
                if (errorEl) errorEl.textContent = 'Path is required.';
                return;
            }

            const formData = { base_path: path };
            if (name) formData.name = name;

            const resp = await post('/api/heroprompt/workspaces', formData);
            if (resp.error) {
                if (errorEl) errorEl.textContent = resp.error;
                return;
            }

            currentWs = resp.name || currentWs;
            localStorage.setItem('heroprompt-current-ws', currentWs);
            await reloadWorkspaces();

            const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
            const base = info?.base_path || '';
            if (base) await loadDir(base);

            hideModal('wsCreate');
        });
    }

    // Refresh workspace handler
    const refreshBtn = el('refreshWs');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', async () => {
            const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
            const base = info?.base_path || '';
            if (base) await loadDir(base);
        });
    }

    // Search handler
    const searchBtn = el('doSearch');
    if (searchBtn) {
        searchBtn.onclick = async () => {
            const q = el('search')?.value?.trim();
            if (!q) return;

            // For now, just show a message since search endpoint might not exist
            const tree = el('tree');
            if (tree) {
                tree.innerHTML = '<div class="text-muted small">Search functionality coming soon...</div>';
            }
        };
    }

    // Copy prompt handler
    const copyPromptBtn = el('copyPrompt');
    if (copyPromptBtn) {
        copyPromptBtn.addEventListener('click', async () => {
            const text = el('promptText')?.value || '';
            try {
                const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/prompt`, {
                    method: 'POST',
                    body: new URLSearchParams({ text })
                });
                const out = await r.text();
                await navigator.clipboard.writeText(out);

                // Show success feedback
                const outputEl = el('promptOutput');
                if (outputEl) {
                    outputEl.innerHTML = '<div class="success-message">Prompt copied to clipboard!</div>';
                    setTimeout(() => {
                        outputEl.innerHTML = '<div class="text-muted small">Generated prompt will appear here</div>';
                    }, 3000);
                }
            } catch (e) {
                console.warn('copy prompt failed', e);
                const outputEl = el('promptOutput');
                if (outputEl) {
                    outputEl.innerHTML = '<div class="error-message">Failed to copy prompt</div>';
                    setTimeout(() => {
                        outputEl.innerHTML = '<div class="text-muted small">Generated prompt will appear here</div>';
                    }, 3000);
                }
            }
        });
    }

    // Workspace details modal handler
    const wsDetailsBtn = el('wsDetailsBtn');
    if (wsDetailsBtn) {
        wsDetailsBtn.addEventListener('click', async () => {
            const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
            if (info && !info.error) {
                const nameEl = el('wdName');
                const pathEl = el('wdPath');
                const errorEl = el('wdError');

                if (nameEl) nameEl.value = info.name || currentWs;
                if (pathEl) pathEl.value = info.base_path || '';
                if (errorEl) errorEl.textContent = '';

                showModal('wsDetails');
            }
        });
    }

    // Workspace manage modal handler
    const openWsManageBtn = el('openWsManage');
    if (openWsManageBtn) {
        openWsManageBtn.addEventListener('click', async () => {
            const list = el('wmList');
            const err = el('wmError');
            if (!list) return;

            if (err) err.textContent = '';
            list.innerHTML = '<div class="text-muted">Loading workspaces...</div>';

            const names = await api('/api/heroprompt/workspaces');
            list.innerHTML = '';

            if (names.error || !Array.isArray(names)) {
                list.innerHTML = '<div class="error-message">Failed to load workspaces</div>';
                return;
            }

            for (const n of names) {
                const item = document.createElement('div');
                item.className = 'list-group-item d-flex justify-content-between align-items-center';

                const span = document.createElement('span');
                span.textContent = n;

                const btn = document.createElement('button');
                btn.className = 'btn btn-sm btn-primary';
                btn.textContent = 'Use';
                btn.onclick = async () => {
                    currentWs = n;
                    localStorage.setItem('heroprompt-current-ws', currentWs);
                    await reloadWorkspaces();
                    const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
                    const base = info?.base_path || '';
                    if (base) await loadDir(base);
                    hideModal('wsManage');
                };

                item.appendChild(span);
                item.appendChild(btn);
                list.appendChild(item);
            }

            showModal('wsManage');
        });
    }
});

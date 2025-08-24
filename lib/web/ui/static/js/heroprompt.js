console.log('Enhanced HeroPrompt UI loaded');

// Global state
let currentWs = localStorage.getItem('heroprompt-current-ws') || 'default';
let selected = new Set();
let expandedDirs = new Set();
let searchQuery = '';

// Utility functions
const el = (id) => document.getElementById(id);
const qs = (selector) => document.querySelector(selector);
const qsa = (selector) => document.querySelectorAll(selector);

// API helpers
async function api(url) {
    try {
        const r = await fetch(url);
        if (!r.ok) {
            console.warn(`API call failed: ${url} - ${r.status}`);
            return { error: `HTTP ${r.status}` };
        }
        return await r.json();
    } catch (e) {
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
    } catch (e) {
        console.warn(`POST error: ${url}`, e);
        return { error: 'request failed' };
    }
}

// Modal helpers
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

// Tab management
function switchTab(tabName) {
    // Update tab buttons
    qsa('.tab').forEach(tab => {
        tab.classList.remove('active');
        if (tab.getAttribute('data-tab') === tabName) {
            tab.classList.add('active');
        }
    });

    // Update tab panes
    qsa('.tab-pane').forEach(pane => {
        pane.style.display = 'none';
        if (pane.id === `tab-${tabName}`) {
            pane.style.display = 'block';
        }
    });
}

// Simple and clean file tree implementation
class SimpleFileTree {
    constructor(container) {
        this.container = container;
        this.loadedPaths = new Set();
    }

    createFileItem(item, path, depth = 0) {
        const div = document.createElement('div');
        div.className = 'tree-item';
        div.style.paddingLeft = `${depth * 16}px`;
        div.dataset.path = path;
        div.dataset.type = item.type;

        const content = document.createElement('div');
        content.className = 'tree-item-content';

        // Checkbox
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.className = 'tree-checkbox';
        checkbox.checked = selected.has(path);
        checkbox.addEventListener('change', () => {
            if (checkbox.checked) {
                selected.add(path);
            } else {
                selected.delete(path);
            }
            this.updateSelectionUI();
        });

        // Expand/collapse button for directories
        let expandBtn = null;
        if (item.type === 'directory') {
            expandBtn = document.createElement('button');
            expandBtn.className = 'tree-expand-btn';
            expandBtn.innerHTML = expandedDirs.has(path) ? '▼' : '▶';
            expandBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.toggleDirectory(path, expandBtn);
            });
        } else {
            // Spacer for files to align with directories
            expandBtn = document.createElement('span');
            expandBtn.className = 'tree-expand-spacer';
        }

        // Icon
        const icon = document.createElement('span');
        icon.className = 'tree-icon';
        icon.textContent = item.type === 'directory' ? '📁' : '📄';

        // Label
        const label = document.createElement('span');
        label.className = 'tree-label';
        label.textContent = item.name;
        label.addEventListener('click', () => {
            if (item.type === 'file') {
                this.previewFile(path);
            } else {
                this.toggleDirectory(path, expandBtn);
            }
        });

        content.appendChild(checkbox);
        content.appendChild(expandBtn);
        content.appendChild(icon);
        content.appendChild(label);
        div.appendChild(content);

        return div;
    }

    async toggleDirectory(dirPath, expandBtn) {
        const isExpanded = expandedDirs.has(dirPath);

        if (isExpanded) {
            // Collapse
            expandedDirs.delete(dirPath);
            expandBtn.innerHTML = '▶';
            this.removeChildren(dirPath);
        } else {
            // Expand
            expandedDirs.add(dirPath);
            expandBtn.innerHTML = '▼';
            await this.loadChildren(dirPath);
        }
    }

    removeChildren(parentPath) {
        const items = qsa('.tree-item');
        items.forEach(item => {
            const itemPath = item.dataset.path;
            if (itemPath !== parentPath && itemPath.startsWith(parentPath + '/')) {
                item.remove();
            }
        });
    }

    async loadChildren(parentPath) {
        if (this.loadedPaths.has(parentPath)) {
            return; // Already loaded
        }

        console.log('Loading children for:', parentPath);
        const r = await api(`/api/heroprompt/directory?name=${currentWs}&path=${encodeURIComponent(parentPath)}`);

        if (r.error) {
            console.warn('Failed to load directory:', parentPath, r.error);
            return;
        }

        console.log('API response for', parentPath, ':', r);

        // Sort items: directories first, then files
        const items = (r.items || []).sort((a, b) => {
            if (a.type !== b.type) {
                return a.type === 'directory' ? -1 : 1;
            }
            return a.name.localeCompare(b.name);
        });

        console.log('Sorted items:', items);

        // Find the parent element
        const parentElement = qs(`[data-path="${parentPath}"]`);
        if (!parentElement) {
            console.warn('Parent element not found for path:', parentPath);
            return;
        }

        const parentDepth = this.getDepth(parentPath);
        console.log('Parent depth:', parentDepth);

        // Insert children after parent
        let insertAfter = parentElement;
        for (const item of items) {
            const childPath = parentPath.endsWith('/') ?
                parentPath + item.name :
                parentPath + '/' + item.name;

            console.log('Creating child:', item.name, 'at path:', childPath, 'depth:', parentDepth + 1);
            const childElement = this.createFileItem(item, childPath, parentDepth + 1);
            insertAfter.insertAdjacentElement('afterend', childElement);
            insertAfter = childElement;
        }

        this.loadedPaths.add(parentPath);
        console.log('Finished loading children for:', parentPath);
    }

    getDepth(path) {
        const depth = (path.match(/\//g) || []).length;
        console.log('Depth for path', path, ':', depth);
        return depth;
    }

    async previewFile(filePath) {
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

    updateSelectionUI() {
        const selCountEl = el('selCount');
        const selCountTabEl = el('selCountTab');
        const tokenCountEl = el('tokenCount');
        const selectedEl = el('selected');

        const count = selected.size;

        if (selCountEl) selCountEl.textContent = count.toString();
        if (selCountTabEl) selCountTabEl.textContent = count.toString();

        // Update selection list
        if (selectedEl) {
            selectedEl.innerHTML = '';

            if (count === 0) {
                selectedEl.innerHTML = `
                    <li class="empty-selection">
                        <i class="icon-empty"></i>
                        <p>No files selected</p>
                        <small>Use checkboxes in the explorer to select files</small>
                    </li>
                `;
            } else {
                Array.from(selected).forEach(path => {
                    const li = document.createElement('li');
                    li.className = 'selected-item';

                    const span = document.createElement('span');
                    span.className = 'item-path';
                    span.textContent = path;

                    const btn = document.createElement('button');
                    btn.className = 'btn btn-xs btn-ghost';
                    btn.innerHTML = '<i class="icon-close"></i>';
                    btn.onclick = () => {
                        this.removeFromSelection(path);
                    };

                    li.appendChild(span);
                    li.appendChild(btn);
                    selectedEl.appendChild(li);
                });
            }
        }

        // Estimate token count (rough approximation)
        const totalChars = Array.from(selected).join('\n').length;
        const tokens = Math.ceil(totalChars / 4);
        if (tokenCountEl) tokenCountEl.textContent = tokens.toString();
    }

    removeFromSelection(path) {
        selected.delete(path);

        // Update checkbox
        const checkbox = qs(`[data-path="${path}"] .tree-checkbox`);
        if (checkbox) {
            checkbox.checked = false;
        }

        this.updateSelectionUI();
    }

    selectAll() {
        qsa('.tree-checkbox').forEach(checkbox => {
            checkbox.checked = true;
            const path = checkbox.closest('.tree-item').dataset.path;
            selected.add(path);
        });
        this.updateSelectionUI();
    }

    clearSelection() {
        selected.clear();
        qsa('.tree-checkbox').forEach(checkbox => {
            checkbox.checked = false;
        });
        this.updateSelectionUI();
    }

    collapseAll() {
        expandedDirs.clear();
        qsa('.tree-expand-btn').forEach(btn => {
            btn.innerHTML = '▶';
        });
        // Remove all children except root level
        qsa('.tree-item').forEach(item => {
            const depth = parseInt(item.style.paddingLeft) / 16;
            if (depth > 0) {
                item.remove();
            }
        });
        this.loadedPaths.clear();
    }

    search(query) {
        searchQuery = query.toLowerCase();

        qsa('.tree-item').forEach(item => {
            const label = item.querySelector('.tree-label');
            if (label) {
                const matches = !searchQuery || label.textContent.toLowerCase().includes(searchQuery);
                item.style.display = matches ? 'block' : 'none';
            }
        });
    }

    async render(workspacePath) {
        this.container.innerHTML = '<div class="loading">Loading workspace...</div>';

        const r = await api(`/api/heroprompt/directory?name=${currentWs}&path=${encodeURIComponent(workspacePath)}`);

        this.container.innerHTML = '';

        if (r.error) {
            this.container.innerHTML = `<div class="error-message">${r.error}</div>`;
            return;
        }

        // Sort items: directories first, then files
        const items = (r.items || []).sort((a, b) => {
            if (a.type !== b.type) {
                return a.type === 'directory' ? -1 : 1;
            }
            return a.name.localeCompare(b.name);
        });

        for (const item of items) {
            const fullPath = workspacePath.endsWith('/') ?
                workspacePath + item.name :
                workspacePath + '/' + item.name;

            const element = this.createFileItem(item, fullPath, 0);
            this.container.appendChild(element);
        }

        this.updateSelectionUI();
    }
}

// Global tree instance
let fileTree = null;

// Workspace management
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

    if (names.includes(currentWs)) {
        sel.value = currentWs;
    } else if (names.length > 0) {
        currentWs = names[0];
        sel.value = currentWs;
        localStorage.setItem('heroprompt-current-ws', currentWs);
    }
}

async function initWorkspace() {
    const names = await api('/api/heroprompt/workspaces');
    if (names.error || !Array.isArray(names) || names.length === 0) {
        console.warn('No workspaces available');
        const treeEl = el('tree');
        if (treeEl) {
            treeEl.innerHTML = `
                <div class="empty-state">
                    <i class="icon-folder-open"></i>
                    <p>No workspaces available</p>
                    <small>Create one to get started</small>
                </div>
            `;
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
    if (base && fileTree) {
        await fileTree.render(base);
    }
}

// Prompt generation
async function generatePrompt() {
    const promptText = el('promptText')?.value || '';
    const outputEl = el('promptOutput');

    if (!outputEl) return;

    if (selected.size === 0) {
        outputEl.innerHTML = '<div class="error-message">No files selected. Please select files first.</div>';
        return;
    }

    outputEl.innerHTML = '<div class="loading">Generating prompt...</div>';

    try {
        // sync selection to backend before generating
        const paths = Array.from(selected);
        await post(`/api/heroprompt/workspaces/${currentWs}/selection`, { paths: JSON.stringify(paths) });

        const r = await fetch(`/api/heroprompt/workspaces/${currentWs}/prompt`, {
            method: 'POST',
            body: new URLSearchParams({ text: promptText })
        });

        const result = await r.text();
        outputEl.textContent = result;
    } catch (e) {
        console.warn('Generate prompt failed', e);
        outputEl.innerHTML = '<div class="error-message">Failed to generate prompt</div>';
    }
}

async function copyPrompt() {
    const outputEl = el('promptOutput');
    if (!outputEl) return;

    const text = outputEl.textContent;
    if (!text || text.includes('No files selected') || text.includes('Failed')) {
        return;
    }

    try {
        await navigator.clipboard.writeText(text);

        // Show success feedback
        const originalContent = outputEl.innerHTML;
        outputEl.innerHTML = '<div class="success-message">Prompt copied to clipboard!</div>';
        setTimeout(() => {
            outputEl.innerHTML = originalContent;
        }, 2000);
    } catch (e) {
        console.warn('Copy failed', e);
        outputEl.innerHTML = '<div class="error-message">Failed to copy prompt</div>';
    }
}

// Initialize everything when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    // Initialize file tree
    const treeContainer = el('tree');
    if (treeContainer) {
        fileTree = new SimpleFileTree(treeContainer);
    }

    // Initialize workspaces
    initWorkspace();
    reloadWorkspaces();

    // Tab switching
    qsa('.tab').forEach(tab => {
        tab.addEventListener('click', function (e) {
            e.preventDefault();
            const tabName = this.getAttribute('data-tab');
            switchTab(tabName);
        });
    });

    // Workspace selector
    const workspaceSelect = el('workspaceSelect');
    if (workspaceSelect) {
        workspaceSelect.addEventListener('change', async (e) => {
            currentWs = e.target.value;
            localStorage.setItem('heroprompt-current-ws', currentWs);
            const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
            const base = info?.base_path || '';
            if (base && fileTree) {
                await fileTree.render(base);
            }
        });
    }

    // Explorer controls
    const collapseAllBtn = el('collapseAll');
    if (collapseAllBtn) {
        collapseAllBtn.addEventListener('click', () => {
            if (fileTree) fileTree.collapseAll();
        });
    }

    const refreshExplorerBtn = el('refreshExplorer');
    if (refreshExplorerBtn) {
        refreshExplorerBtn.addEventListener('click', async () => {
            const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
            const base = info?.base_path || '';
            if (base && fileTree) {
                await fileTree.render(base);
            }
        });
    }

    const selectAllBtn = el('selectAll');
    if (selectAllBtn) {
        selectAllBtn.addEventListener('click', () => {
            if (fileTree) fileTree.selectAll();
        });
    }

    const clearSelectionBtn = el('clearSelection');
    if (clearSelectionBtn) {
        clearSelectionBtn.addEventListener('click', () => {
            if (fileTree) fileTree.clearSelection();
        });
    }

    const clearAllSelectionBtn = el('clearAllSelection');
    if (clearAllSelectionBtn) {
        clearAllSelectionBtn.addEventListener('click', () => {
            if (fileTree) fileTree.clearSelection();
        });
    }

    // Search functionality
    const searchInput = el('search');
    const clearSearchBtn = el('clearSearch');

    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            if (fileTree) {
                fileTree.search(e.target.value);
            }
        });
    }

    if (clearSearchBtn) {
        clearSearchBtn.addEventListener('click', () => {
            if (searchInput) {
                searchInput.value = '';
                if (fileTree) {
                    fileTree.search('');
                }
            }
        });
    }

    // Prompt generation
    const generatePromptBtn = el('generatePrompt');
    if (generatePromptBtn) {
        generatePromptBtn.addEventListener('click', generatePrompt);
    }

    const copyPromptBtn = el('copyPrompt');
    if (copyPromptBtn) {
        copyPromptBtn.addEventListener('click', copyPrompt);
    }

    // Workspace creation modal
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
            if (base && fileTree) {
                await fileTree.render(base);
            }

            hideModal('wsCreate');
        });
    }

    // Workspace details modal
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

    // Workspace management modal
    const openWsManageBtn = el('openWsManage');
    if (openWsManageBtn) {
        openWsManageBtn.addEventListener('click', async () => {
            const list = el('wmList');
            const err = el('wmError');
            if (!list) return;

            if (err) err.textContent = '';
            list.innerHTML = '<div class="loading">Loading workspaces...</div>';

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
                    if (base && fileTree) {
                        await fileTree.render(base);
                    }
                    hideModal('wsManage');
                };

                item.appendChild(span);
                item.appendChild(btn);
                list.appendChild(item);
            }

            showModal('wsManage');
        });
    }

    console.log('Enhanced HeroPrompt UI initialized');
});

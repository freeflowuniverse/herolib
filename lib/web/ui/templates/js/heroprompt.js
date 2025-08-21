/**
 * Heroprompt - Client-side workspace and file selection management
 * Updated to work with V backend API and support subdirectories
 */

class Heroprompt {
    constructor() {
        // Backend-integrated state (no localStorage)
        this.currentWorkspace = '';
        this.workspaces = [];
        this.selectedFiles = new Set();
        this.selectedDirs = new Set();

        this.initializeUI();
        this.bindEvents();
        // Load workspaces from backend and render
        this.refreshWorkspaces();
    }

    // Data management
    loadData() {
        try {
            const stored = localStorage.getItem(this.storageKey);
            if (stored) {
                return JSON.parse(stored);
            }
        } catch (e) {
            console.warn('Failed to load heroprompt data:', e);
        }

        return {
            workspaces: {
                default: { dirs: [] }
            },
            current: 'default'
        };
    }

    saveData() {
        try {
            localStorage.setItem(this.storageKey, JSON.stringify(this.data));
        } catch (e) {
            console.error('Failed to save heroprompt data:', e);
            this.showToast('Failed to save data', 'error');
        }
    }

    // API calls to V backend
    async fetchDirectory(path) {
        try {
            const qs = new URLSearchParams({ name: this.currentWorkspace || 'default', path }).toString();
            const response = await fetch(`/api/heroprompt/directory?${qs}`);
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }
            return await response.json();
        } catch (e) {
            console.error('Failed to fetch directory:', e);
            throw e;
        }
    }

    async fetchFileContent(path) {
        try {
            const qs = new URLSearchParams({ name: this.currentWorkspace || 'default', path }).toString();
            const response = await fetch(`/api/heroprompt/file?${qs}`);
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }
            return await response.json();
        } catch (e) {
            console.error('Failed to fetch file:', e);
            throw e;
        }
    }

    // Workspace management
    createWorkspace(name) {
        if (!name || name.trim() === '') {
            this.showToast('Workspace name cannot be empty', 'error');
            return;
        }

        name = name.trim();
        if (this.data.workspaces[name]) {
            this.showToast('Workspace already exists', 'error');
            return;
        }

        this.data.workspaces[name] = { dirs: [] };
        this.data.current = name;
        this.currentWorkspace = name;
        this.saveData();
        this.render();
        this.showToast(`Workspace "${name}" created`, 'success');
    }

    deleteWorkspace(name) {
        if (name === 'default') {
            this.showToast('Cannot delete default workspace', 'error');
            return;
        }

        if (!confirm(`Are you sure you want to delete workspace "${name}"?`)) {
            return;
        }

        delete this.data.workspaces[name];

        if (this.currentWorkspace === name) {
            this.currentWorkspace = 'default';
            this.data.current = 'default';
        }

        this.saveData();
        this.render();
        this.showToast(`Workspace "${name}" deleted`, 'success');
    }

    selectWorkspace(name) {
        if (!this.data.workspaces[name]) {
            this.showToast('Workspace not found', 'error');
            return;
        }

        this.currentWorkspace = name;
        this.data.current = name;
        this.saveData();
        this.render();
    }

    // Directory management
    async addDirectory() {
        // Try to use the File System Access API if available
        if ('showDirectoryPicker' in window) {
            await this.addDirectoryWithPicker();
        } else {
            this.addDirectoryWithPrompt();
        }
    }
    // Backend API helpers
    async apiListWorkspaces() {
        const res = await fetch('/api/heroprompt/workspaces');
        if (!res.ok) throw new Error('Failed to list workspaces');
        return await res.json(); // array of names
    }

    async apiCreateWorkspace(name, base_path = '') {
        const form = new FormData();
        form.append('name', name);
        if (base_path) form.append('base_path', base_path);
        const res = await fetch('/api/heroprompt/workspaces', { method: 'POST', body: form });
        if (!res.ok) throw new Error('Failed to create workspace');
        return await res.json();
    }

    async apiDeleteWorkspace(name) {
        const res = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(name)}`, { method: 'DELETE' });
        if (!res.ok) throw new Error('Failed to delete workspace');
        return await res.json();
    }

    async refreshWorkspaces(selectName = '') {
        try {
            this.workspaces = await this.apiListWorkspaces();
            if (this.workspaces.length > 0) {
                this.currentWorkspace = selectName || this.currentWorkspace || this.workspaces[0];
            } else {
                this.currentWorkspace = '';
            }
            await this.render();
        } catch (e) {
            console.error(e);
            this.showToast('Failed to load workspaces', 'error');
        }
    }
    async apiGetWorkspace(name) {
        const res = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(name)}`);
        if (!res.ok) throw new Error('Failed to get workspace');
        return await res.json();
    }

    async apiAddDir(path) {
        const form = new FormData();
        form.append('path', path);
        const res = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(this.currentWorkspace)}/dirs`, {
            method: 'POST', body: form
        });
        if (!res.ok) throw new Error('Failed to add directory');
        return await res.json();
    }

    async apiRemoveDir(path) {
        const form = new FormData();
        form.append('path', path);
        const res = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(this.currentWorkspace)}/dirs/remove`, {
            method: 'POST', body: form
        });
        if (!res.ok) throw new Error('Failed to remove directory');
        return await res.json();
    }

    async apiAddFile(path) {
        const form = new FormData();
        form.append('path', path);
        const res = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(this.currentWorkspace)}/files`, {
            method: 'POST', body: form
        });
        if (!res.ok) throw new Error('Failed to add file');
        return await res.json();
    }

    async apiRemoveFile(path) {
        const form = new FormData();
        form.append('path', path);
        const res = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(this.currentWorkspace)}/files/remove`, {
            method: 'POST', body: form
        });
        if (!res.ok) throw new Error('Failed to remove file');
        return await res.json();
    }

    async loadCurrentWorkspaceDetails() {
        if (!this.currentWorkspace) {
            this.currentDetails = null;
            this.selectedFiles = new Set();
            this.selectedDirs = new Set();
            return;
        }
        const data = await this.apiGetWorkspace(this.currentWorkspace);
        this.currentDetails = data;
        const files = new Set();
        const dirs = new Set();
        for (const ch of (data.children || [])) {
            if (ch.type === 'file') files.add(ch.path);
            if (ch.type === 'directory') dirs.add(ch.path);
        }
        this.selectedFiles = files;
        this.selectedDirs = dirs;
    }



    async addDirectoryWithPicker() {
        try {
            const dirHandle = await window.showDirectoryPicker();

            // For File System Access API, we need to read the directory contents directly
            // since we can't pass the handle to the backend
            const files = [];
            const subdirs = [];

            for await (const [name, handle] of dirHandle.entries()) {
                if (handle.kind === 'file') {
                    files.push(name);
                } else if (handle.kind === 'directory') {
                    subdirs.push(name);
                }
            }

            const processedDir = {
                path: dirHandle.name, // Use the directory name as path for now
                files: files.sort(),
                subdirs: subdirs.sort(),
                selected: []
            };

            this.data.workspaces[this.currentWorkspace].dirs.push(processedDir);
            this.saveData();
            this.render();
            this.showToast(`Directory "${dirHandle.name}" added`, 'success');

        } catch (e) {
            if (e.name !== 'AbortError') {
                console.error('Directory picker error:', e);
                this.showToast('Failed to access directory', 'error');
            }
        }
    }

    async processDirectoryHandle(dirHandle, basePath = '') {
        // This method is no longer used with the File System Access API approach
        // but kept for compatibility
        try {
            const fullPath = basePath ? `${basePath}/${dirHandle.name}` : dirHandle.name;
            const dirData = await this.fetchDirectory(fullPath);

            // Check if we got an error response
            if (dirData.error) {
                throw new Error(dirData.error);
            }

            // Process the directory structure from the backend
            const processedDir = {
                path: dirData.path,
                files: [],
                subdirs: [],
                selected: []
            };

            // Separate files and directories
            if (dirData.items && Array.isArray(dirData.items)) {
                for (const item of dirData.items) {
                    if (item.type === 'file') {
                        processedDir.files.push(item.name);
                    } else if (item.type === 'directory') {
                        processedDir.subdirs.push(item.name);
                    }
                }
            }

            this.data.workspaces[this.currentWorkspace].dirs.push(processedDir);
            this.saveData();
            this.render();
            this.showToast(`Directory "${dirHandle.name}" added`, 'success');

        } catch (e) {
            console.error('Failed to process directory:', e);
            this.showToast('Failed to process directory', 'error');
        }
    }

    async addDirectoryWithPrompt() {
        const path = prompt('Enter directory path:');
        if (!path || path.trim() === '') return;
        try {
            await this.apiAddDir(path.trim());
            await this.render();
            this.showToast(`Directory "${path}" added`, 'success');
        } catch (e) {
            console.error('Failed to add directory:', e);
            this.showToast(`Failed to add directory: ${e.message}`, 'error');
        }
    }

    async removeDirectory(path) {
        if (!confirm('Are you sure you want to remove this directory?')) return;
        try {
            await this.apiRemoveDir(path);
            await this.render();
            this.showToast('Directory removed', 'success');
        } catch (e) {
            console.error('Failed to remove directory:', e);
            this.showToast('Failed to remove directory', 'error');
        }
    }

    // File selection management (backend-synced)
    async toggleFileSelection(filePath) {
        try {
            if (this.selectedFiles.has(filePath)) {
                await this.apiRemoveFile(filePath);
                this.selectedFiles.delete(filePath);
            } else {
                await this.apiAddFile(filePath);
                this.selectedFiles.add(filePath);
            }
            await this.renderWorkspaceDetails();
        } catch (e) {
            console.error('Failed to toggle file selection:', e);
            this.showToast('Failed to toggle file selection', 'error');
        }
    }

    selectAllFiles(workspaceName, dirIndex) {
        const dir = this.data.workspaces[workspaceName].dirs[dirIndex];
        dir.selected = [...dir.files];
        this.saveData();
        this.renderWorkspaceDetails();
    }

    deselectAllFiles(workspaceName, dirIndex) {
        const dir = this.data.workspaces[workspaceName].dirs[dirIndex];
        dir.selected = [];
        this.saveData();
        this.renderWorkspaceDetails();
    }

    // Generate file tree structure
    generateFileTree(dirPath, files, subdirs) {
        const lines = [];
        const dirName = dirPath.split('/').pop() || dirPath;

        lines.push(`${dirPath}`);

        // Add files
        files.forEach((file, index) => {
            const isLast = index === files.length - 1 && subdirs.length === 0;
            lines.push(`${isLast ? '└──' : '├──'} ${file}`);
        });

        // Add subdirectories (placeholder for now)
        subdirs.forEach((subdir, index) => {
            const isLast = index === subdirs.length - 1;
            lines.push(`${isLast ? '└──' : '├──'} ${subdir}/`);
        });

        return lines.join('\n');
    }

    // Clipboard functionality with new format
    async copySelection() {
        if (!this.currentWorkspace) {
            this.showToast('Select a workspace first', 'error');
            return;
        }

        const userInstructions = document.getElementById('user-instructions').value.trim();
        if (!userInstructions) {
            this.showToast('Please enter user instructions', 'error');
            return;
        }

        let hasSelection = false;
        const output = [];

        // Add user instructions
        output.push('<user_instructions>');
        output.push(userInstructions);
        output.push('</user_instructions>');
        output.push('');

        // Generate file map
        output.push('<file_map>');
        const dirSet = new Set(Array.from(this.selectedFiles).map(p => p.split('/').slice(0, -1).join('/')));
        for (const dirPath of dirSet) {
            const data = await this.fetchDirectory(dirPath);
            const files = (data.items || []).filter(it => it.type === 'file').map(it => it.name);
            const subdirs = (data.items || []).filter(it => it.type === 'directory').map(it => it.name);
            const fileTree = this.generateFileTree(dirPath, files, subdirs);
            output.push(fileTree);
        }
        output.push('</file_map>');
        output.push('');

        if (this.selectedFiles.size === 0) {
            this.showToast('No files selected', 'error');
            return;
        }

        // Generate file contents
        output.push('<file_contents>');

        try {
            for (const filePath of Array.from(this.selectedFiles)) {
                try {
                    const fileData = await this.fetchFileContent(filePath);
                    output.push(`File: ${filePath}`);
                    output.push('');
                    output.push(`\`\`\`${fileData.language}`);
                    output.push(fileData.content);
                    output.push('```');
                    output.push('');
                } catch (e) {
                    console.error(`Failed to fetch file ${filePath}:`, e);
                    output.push(`File: ${filePath}`);
                    output.push('');
                    output.push('```text');
                    output.push(`Error: Failed to read file - ${e.message}`);
                    output.push('```');
                    output.push('');
                }
            }
        } catch (e) {
            console.error('Error fetching file contents:', e);
            this.showToast('Error fetching file contents', 'error');
            return;
        }

        output.push('</file_contents>');

        const text = output.join('\n');

        if (navigator.clipboard && navigator.clipboard.writeText) {
            try {
                await navigator.clipboard.writeText(text);
                this.showToast('Selection copied to clipboard', 'success');
            } catch (e) {
                console.error('Clipboard error:', e);
                this.fallbackCopyToClipboard(text);
            }
        } else {
            this.fallbackCopyToClipboard(text);
        }
    }

    fallbackCopyToClipboard(text) {
        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.left = '-999999px';
        textArea.style.top = '-999999px';
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();

        try {
            document.execCommand('copy');
            this.showToast('Selection copied to clipboard', 'success');
        } catch (e) {
            console.error('Fallback copy failed:', e);
            this.showToast('Failed to copy to clipboard', 'error');
        }

        document.body.removeChild(textArea);
    }

    // UI Management
    initializeUI() {
        // Cache DOM elements
        this.elements = {
            workspaceSelect: document.getElementById('workspace-select'),
            workspaceContent: document.getElementById('workspace-content'),
            currentWorkspaceName: document.getElementById('current-workspace-name'),
            createWorkspaceBtn: document.getElementById('create-workspace'),
            deleteWorkspaceBtn: document.getElementById('delete-workspace'),
            addDirectoryBtn: document.getElementById('add-directory'),
            copySelectionBtn: document.getElementById('copy-selection'),
            clearInstructionsBtn: document.getElementById('clear-instructions'),
            userInstructions: document.getElementById('user-instructions'),
            toast: document.getElementById('notification-toast')
        };
    }

    bindEvents() {
        // Workspace management
        this.elements.createWorkspaceBtn.addEventListener('click', async () => {
            const name = prompt('Enter workspace name:');
            if (!name) return;
            const base_path = prompt('Enter base path for this workspace (optional):') || '';
            try {
                await this.apiCreateWorkspace(name.trim(), base_path.trim());
                await this.refreshWorkspaces(name.trim());
                this.showToast(`Workspace "${name}" created`, 'success');
            } catch (e) {
                console.error(e);
                this.showToast('Failed to create workspace', 'error');
            }
        });

        this.elements.deleteWorkspaceBtn.addEventListener('click', async () => {
            if (!this.currentWorkspace) return;
            if (!confirm(`Are you sure you want to delete workspace "${this.currentWorkspace}"?`)) return;
            try {
                await this.apiDeleteWorkspace(this.currentWorkspace);
                await this.refreshWorkspaces();
                this.showToast('Workspace deleted', 'success');
            } catch (e) {
                console.error(e);
                this.showToast('Failed to delete workspace', 'error');
            }
        });

        this.elements.workspaceSelect.addEventListener('change', async () => {
            this.currentWorkspace = this.elements.workspaceSelect.value;
            await this.render();
        });

        // Directory management
        this.elements.addDirectoryBtn.addEventListener('click', () => {
            this.addDirectory();
        });

        // Copy selection
        this.elements.copySelectionBtn.addEventListener('click', () => {
            this.copySelection();
        });

        // Clear instructions
        this.elements.clearInstructionsBtn.addEventListener('click', () => {
            this.elements.userInstructions.value = '';
        });
    }

    render() {
        this.renderWorkspaceSelect();
        this.renderWorkspaceDetails();
    }

    renderWorkspaceSelect() {
        const names = this.workspaces;
        const options = names.map(n => `<option value="${n}" ${n === this.currentWorkspace ? 'selected' : ''}>${n}</option>`).join('');
        this.elements.workspaceSelect.innerHTML = options;
        this.elements.deleteWorkspaceBtn.style.display = this.currentWorkspace && this.currentWorkspace !== 'default' ? 'inline-block' : 'none';
        this.elements.currentWorkspaceName.textContent = this.currentWorkspace || 'Select a workspace';
    }

    renderWorkspaceDetails() {
        const workspace = this.data.workspaces[this.currentWorkspace];

        // Update header
        this.elements.currentWorkspaceName.textContent = this.currentWorkspace;

        // Show/hide buttons based on selection
        const hasWorkspace = !!this.currentWorkspace;
        this.elements.deleteWorkspaceBtn.style.display = hasWorkspace && this.currentWorkspace !== 'default' ? 'inline-block' : 'none';
        this.elements.addDirectoryBtn.style.display = hasWorkspace ? 'inline-block' : 'none';
        this.elements.copySelectionBtn.style.display = hasWorkspace ? 'inline-block' : 'none';

        if (!workspace) {
            this.elements.workspaceContent.innerHTML = '<p class="text-muted">Select a workspace to view its directories and files.</p>';
            return;
        }

        if (workspace.dirs.length === 0) {
            this.elements.workspaceContent.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📁</div>
                    <p>No directories added to this workspace.</p>
                    <p class="text-muted">Click "Add Directory" to get started.</p>
                </div>
            `;
            return;
        }

        // Load current workspace details from backend
        try {
            await this.loadCurrentWorkspaceDetails();
        } catch (e) {
            console.error(e);
            this.elements.workspaceContent.innerHTML = '<p class="text-muted">Failed to load workspace details.</p>';
            return;
        }

        const dirs = Array.from(this.selectedDirs);
        if (dirs.length === 0) {
            this.elements.workspaceContent.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📁</div>
                    <p>No directories added to this workspace.</p>
                    <p class="text-muted">Click "Add Directory" to get started.</p>
                </div>
            `;
            return;
        }

        // Render directories as expandable tree explorers
        this.elements.workspaceContent.innerHTML = dirs.map((dirPath, dirIndex) => `
            <div class="directory-item">
                <div class="directory-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>${this.getDirectoryName(dirPath)}</strong>
                            <div class="directory-path">${dirPath}</div>
                        </div>
                        <div class="btn-group-actions">
                            <button class="btn btn-sm btn-outline-danger" onclick="heroprompt.removeDirectory('${dirPath}')">Remove</button>
                        </div>
                    </div>
                </div>
                <div class="file-tree" id="file-tree-${dirIndex}"></div>
            </div>
        `).join('');

        // Populate tree nodes asynchronously
        dirs.forEach((dirPath, dirIndex) => {
            const container = document.getElementById(`file-tree-${dirIndex}`);
            this.renderDirNode(dirPath, dirIndex, container, 0);
        });
    }
    // Render a directory node with lazy subdir loading
    async renderDirNode(dirPath, dirIndex, container, level) {
        try {
            // Fetch directory listing from backend
            const data = await this.fetchDirectory(dirPath);
            const items = data.items || [];

            // Separate directories and files
            const dirs = items.filter(it => it.type === 'directory').map(it => it.name);
            const files = items.filter(it => it.type === 'file').map(it => it.name);

            // Build HTML
            const indent = '&nbsp;'.repeat(level * 2);
            const list = [];

            dirs.forEach(sub => {
                const subPath = `${dirPath}/${sub}`;
                const nodeId = `dir-node-${dirIndex}-${level}-${sub.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
                list.push(`
                    <div class="file-item">
                        <span class="file-icon">📁</span>
                        <a href="#" class="toggle" data-target="${nodeId}" data-path="${subPath}">${indent}${sub}</a>
                        <div id="${nodeId}" class="children" style="display:none; margin-left:12px;"></div>
                    </div>
                `);
            });

            files.forEach(file => {
                const absPath = `${dirPath}/${file}`;
                const isSel = this.selectedFiles.has(absPath);
                list.push(`
                    <div class="file-item ${isSel ? 'selected' : ''}" onclick="heroprompt.toggleFileSelection('${absPath}')">
                        <input type="checkbox" ${isSel ? 'checked' : ''} onclick="event.stopPropagation()">
                        <span class="file-icon ${this.getFileIconClass(file)}"></span>
                        <span class="file-name">${indent}${file}</span>
                    </div>
                `);
            });

            container.innerHTML = list.join('');

            // Bind toggles for lazy load
            container.querySelectorAll('a.toggle').forEach(a => {
                a.addEventListener('click', async (e) => {
                    e.preventDefault();
                    const targetId = a.getAttribute('data-target');
                    const path = a.getAttribute('data-path');
                    const target = document.getElementById(targetId);
                    if (target.getAttribute('data-loaded') !== '1') {
                        await this.renderDirNode(path, dirIndex, target, level + 1);
                        target.setAttribute('data-loaded', '1');
                    }
                    target.style.display = (target.style.display === 'none') ? 'block' : 'none';
                });
            });
        } catch (e) {
            console.error('Failed to render directory node:', e);
            container.innerHTML = `<div class="text-muted small">Failed to load ${dirPath}</div>`;
        }
    }

    getDirectoryName(path) {
        return path.split('/').pop() || path.split('\\').pop() || path;
    }

    getFileIconClass(fileName) {
        const ext = fileName.split('.').pop().toLowerCase();
        return `file-${ext}` || 'file-default';
    }

    showToast(message, type = 'info') {
        const toast = this.elements.toast;
        const toastBody = toast.querySelector('.toast-body');

        toastBody.textContent = message;

        // Set toast color based on type
        toast.className = 'toast';
        if (type === 'success') {
            toast.classList.add('text-bg-success');
        } else if (type === 'error') {
            toast.classList.add('text-bg-danger');
        } else {
            toast.classList.add('text-bg-info');
        }

        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.heroprompt = new Heroprompt();
});

// Export for potential external use
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Heroprompt;
}
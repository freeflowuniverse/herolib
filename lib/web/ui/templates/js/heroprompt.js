/**
 * Heroprompt - Client-side workspace and file selection management
 * Updated to work with V backend API and support subdirectories
 */

class Heroprompt {
    constructor() {
        this.storageKey = 'heroprompt_data';
        this.data = this.loadData();
        this.currentWorkspace = this.data.current || 'default';

        // Ensure default workspace exists
        if (!this.data.workspaces.default) {
            this.data.workspaces.default = { dirs: [] };
            this.saveData();
        }

        this.initializeUI();
        this.bindEvents();
        this.render();
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
            const response = await fetch(`/api/heroprompt/directory?path=${encodeURIComponent(path)}`);
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
            const response = await fetch(`/api/heroprompt/file?path=${encodeURIComponent(path)}`);
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

    addDirectoryWithPrompt() {
        const path = prompt('Enter directory path:');
        if (!path || path.trim() === '') {
            return;
        }

        this.fetchDirectory(path.trim())
            .then(dirData => {
                // Check if we got an error response
                if (dirData.error) {
                    throw new Error(dirData.error);
                }

                const processedDir = {
                    path: dirData.path || path.trim(),
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
                this.showToast(`Directory "${path}" added`, 'success');
            })
            .catch(e => {
                console.error('Failed to add directory:', e);
                this.showToast(`Failed to add directory: ${e.message}`, 'error');
            });
    }

    removeDirectory(workspaceName, dirIndex) {
        if (!confirm('Are you sure you want to remove this directory?')) {
            return;
        }

        this.data.workspaces[workspaceName].dirs.splice(dirIndex, 1);
        this.saveData();
        this.render();
        this.showToast('Directory removed', 'success');
    }

    // File selection management
    toggleFileSelection(workspaceName, dirIndex, fileName) {
        const dir = this.data.workspaces[workspaceName].dirs[dirIndex];
        const selectedIndex = dir.selected.indexOf(fileName);

        if (selectedIndex === -1) {
            dir.selected.push(fileName);
        } else {
            dir.selected.splice(selectedIndex, 1);
        }

        this.saveData();
        this.renderWorkspaceDetails();
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
        const workspace = this.data.workspaces[this.currentWorkspace];
        if (!workspace || workspace.dirs.length === 0) {
            this.showToast('No directories in workspace', 'error');
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
        for (const dir of workspace.dirs) {
            if (dir.selected.length > 0) {
                hasSelection = true;
                const fileTree = this.generateFileTree(dir.path, dir.files, dir.subdirs || []);
                output.push(fileTree);
            }
        }
        output.push('</file_map>');
        output.push('');

        if (!hasSelection) {
            this.showToast('No files selected', 'error');
            return;
        }

        // Generate file contents
        output.push('<file_contents>');

        try {
            for (const dir of workspace.dirs) {
                for (const fileName of dir.selected) {
                    const filePath = `${dir.path}/${fileName}`;
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
            workspaceList: document.getElementById('workspace-list'),
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
        this.elements.createWorkspaceBtn.addEventListener('click', () => {
            const name = prompt('Enter workspace name:');
            if (name) {
                this.createWorkspace(name);
            }
        });

        this.elements.deleteWorkspaceBtn.addEventListener('click', () => {
            this.deleteWorkspace(this.currentWorkspace);
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
        this.renderWorkspaceList();
        this.renderWorkspaceDetails();
    }

    renderWorkspaceList() {
        const workspaceNames = Object.keys(this.data.workspaces).sort();

        this.elements.workspaceList.innerHTML = workspaceNames.map(name => `
            <div class="list-group-item workspace-item ${name === this.currentWorkspace ? 'active' : ''}" 
                 data-workspace="${name}">
                <div class="d-flex justify-content-between align-items-center">
                    <span>${name}</span>
                    <small class="text-muted">${this.data.workspaces[name].dirs.length} dirs</small>
                </div>
            </div>
        `).join('');

        // Bind workspace selection events
        this.elements.workspaceList.querySelectorAll('.workspace-item').forEach(item => {
            item.addEventListener('click', () => {
                const workspaceName = item.dataset.workspace;
                this.selectWorkspace(workspaceName);
            });
        });
    }

    renderWorkspaceDetails() {
        const workspace = this.data.workspaces[this.currentWorkspace];

        // Update header
        this.elements.currentWorkspaceName.textContent = this.currentWorkspace;

        // Show/hide buttons based on selection
        const hasWorkspace = !!workspace;
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

        // Render directories and files
        this.elements.workspaceContent.innerHTML = workspace.dirs.map((dir, dirIndex) => `
            <div class="directory-item">
                <div class="directory-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>${this.getDirectoryName(dir.path)}</strong>
                            <div class="directory-path">${dir.path}</div>
                            ${dir.subdirs && dir.subdirs.length > 0 ? `<div class="text-muted small">Subdirs: ${dir.subdirs.join(', ')}</div>` : ''}
                        </div>
                        <div class="btn-group-actions">
                            <span class="selection-counter ${dir.selected.length > 0 ? 'has-selection' : ''}">
                                ${dir.selected.length}/${dir.files.length} selected
                            </span>
                            <button class="btn btn-sm btn-outline-secondary" onclick="heroprompt.selectAllFiles('${this.currentWorkspace}', ${dirIndex})">All</button>
                            <button class="btn btn-sm btn-outline-secondary" onclick="heroprompt.deselectAllFiles('${this.currentWorkspace}', ${dirIndex})">None</button>
                            <button class="btn btn-sm btn-outline-danger" onclick="heroprompt.removeDirectory('${this.currentWorkspace}', ${dirIndex})">Remove</button>
                        </div>
                    </div>
                </div>
                <div class="file-list">
                    ${dir.files.map(file => `
                        <div class="file-item ${dir.selected.includes(file) ? 'selected' : ''}" 
                             onclick="heroprompt.toggleFileSelection('${this.currentWorkspace}', ${dirIndex}, '${file}')">
                            <input type="checkbox" ${dir.selected.includes(file) ? 'checked' : ''} 
                                   onclick="event.stopPropagation()">
                            <span class="file-icon ${this.getFileIconClass(file)}"></span>
                            <span class="file-name">${file}</span>
                        </div>
                    `).join('')}
                </div>
            </div>
        `).join('');
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
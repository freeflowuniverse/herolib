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

// File extension detection utility
const getFileExtension = (filename) => {
    const parts = filename.split('.');
    return parts.length > 1 ? parts.pop().toLowerCase() : '';
};

// File size formatting utility
const formatFileSize = (bytes) => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
};

// Date formatting utility
const formatDate = (date) => {
    const now = new Date();
    const diffTime = Math.abs(now - date);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays === 1) return 'Yesterday';
    if (diffDays < 7) return `${diffDays} days ago`;
    if (diffDays < 30) return `${Math.ceil(diffDays / 7)} weeks ago`;
    return date.toLocaleDateString();
};

// File icon mapping utility
const getFileIcon = (extension) => {
    const iconMap = {
        'js': '📜', 'ts': '📜', 'html': '🌐', 'css': '🎨', 'json': '📋',
        'md': '📝', 'txt': '📄', 'v': '⚡', 'go': '🐹', 'py': '🐍',
        'java': '☕', 'cpp': '⚙️', 'c': '⚙️', 'rs': '🦀', 'php': '🐘',
        'rb': '💎', 'sh': '🐚', 'yml': '📄', 'yaml': '📄', 'xml': '📄',
        'svg': '🖼️', 'png': '🖼️', 'jpg': '🖼️', 'jpeg': '🖼️', 'gif': '🖼️',
        'pdf': '📕', 'zip': '📦', 'tar': '📦', 'gz': '📦'
    };
    return iconMap[extension] || '📄';
};

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

// Enhanced file tree implementation with better spacing and reliability
class SimpleFileTree {
    constructor(container) {
        this.container = container;
        this.loadedPaths = new Set();
        this.expandedDirs = new Set(); // Track expanded state locally
    }

    createFileItem(item, path, depth = 0) {
        const div = document.createElement('div');
        div.className = 'tree-item';
        div.dataset.path = path;
        div.dataset.type = item.type;
        div.dataset.depth = depth;

        const content = document.createElement('div');
        content.className = 'tree-item-content';
        // Use consistent 20px indentation per level
        content.style.paddingLeft = `${depth * 20 + 8}px`;

        // Checkbox
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.className = 'tree-checkbox';
        checkbox.checked = selected.has(path);
        checkbox.addEventListener('change', (e) => {
            e.stopPropagation();
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
            expandBtn.innerHTML = this.expandedDirs.has(path) ? '▼' : '▶';
            expandBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.toggleDirectory(path);
            });
        } else {
            // Spacer for files to align with directories
            expandBtn = document.createElement('span');
            expandBtn.className = 'tree-expand-spacer';
        }

        // Icon
        const icon = document.createElement('span');
        icon.className = 'tree-icon';
        icon.textContent = item.type === 'directory' ?
            (this.expandedDirs.has(path) ? '📂' : '�') : '📄';

        // Label
        const label = document.createElement('span');
        label.className = 'tree-label';
        label.textContent = item.name;
        label.addEventListener('click', (e) => {
            e.stopPropagation();
            if (item.type === 'file') {
                // Toggle file selection when clicking on file name
                checkbox.checked = !checkbox.checked;
                if (checkbox.checked) {
                    selected.add(path);
                } else {
                    selected.delete(path);
                }
                this.updateSelectionUI();
            } else {
                // Toggle directory expansion when clicking on directory name
                this.toggleDirectory(path);
            }
        });

        content.appendChild(checkbox);
        content.appendChild(expandBtn);
        content.appendChild(icon);
        content.appendChild(label);
        div.appendChild(content);

        return div;
    }

    async toggleDirectory(dirPath) {
        const isExpanded = this.expandedDirs.has(dirPath);
        const dirElement = qs(`[data-path="${dirPath}"]`);
        const expandBtn = dirElement?.querySelector('.tree-expand-btn');
        const icon = dirElement?.querySelector('.tree-icon');

        if (isExpanded) {
            // Collapse
            this.expandedDirs.delete(dirPath);
            if (expandBtn) expandBtn.innerHTML = '▶';
            if (icon) icon.textContent = '📁';
            this.removeChildren(dirPath);
            // Remove from loaded paths so it can be reloaded when expanded again
            this.loadedPaths.delete(dirPath);
        } else {
            // Expand
            this.expandedDirs.add(dirPath);
            if (expandBtn) expandBtn.innerHTML = '▼';
            if (icon) icon.textContent = '📂';
            await this.loadChildren(dirPath);
        }
    }

    removeChildren(parentPath) {
        const items = qsa('.tree-item');
        const toRemove = [];

        items.forEach(item => {
            const itemPath = item.dataset.path;
            if (itemPath !== parentPath && itemPath.startsWith(parentPath + '/')) {
                toRemove.push(item);
                // Also remove from expanded dirs if it was expanded
                this.expandedDirs.delete(itemPath);
                this.loadedPaths.delete(itemPath);
            }
        });

        // Remove elements with animation
        toRemove.forEach(item => {
            item.style.transition = 'opacity 0.2s ease, max-height 0.2s ease';
            item.style.opacity = '0';
            item.style.maxHeight = '0';
            setTimeout(() => item.remove(), 200);
        });
    }

    async loadChildren(parentPath) {
        // Always reload children to ensure fresh data
        console.log('Loading children for:', parentPath);
        const r = await api(`/api/heroprompt/directory?name=${currentWs}&path=${encodeURIComponent(parentPath)}`);

        if (r.error) {
            console.warn('Failed to load directory:', parentPath, r.error);
            return;
        }

        // Sort items: directories first, then files
        const items = (r.items || []).sort((a, b) => {
            if (a.type !== b.type) {
                return a.type === 'directory' ? -1 : 1;
            }
            return a.name.localeCompare(b.name);
        });

        // Find the parent element
        const parentElement = qs(`[data-path="${parentPath}"]`);
        if (!parentElement) {
            console.warn('Parent element not found for path:', parentPath);
            return;
        }

        const parentDepth = parseInt(parentElement.dataset.depth || '0');

        // Create document fragment for efficient DOM manipulation
        const fragment = document.createDocumentFragment();
        const childElements = [];

        // Create all child elements first
        for (const item of items) {
            const childPath = parentPath.endsWith('/') ?
                parentPath + item.name :
                parentPath + '/' + item.name;

            const childElement = this.createFileItem(item, childPath, parentDepth + 1);

            // Prepare for animation
            childElement.style.opacity = '0';
            childElement.style.maxHeight = '0';
            childElement.style.transition = 'opacity 0.2s ease, max-height 0.2s ease';

            fragment.appendChild(childElement);
            childElements.push(childElement);
        }

        // Insert all elements at once
        parentElement.insertAdjacentElement('afterend', fragment.firstChild);
        if (fragment.children.length > 1) {
            let insertAfter = parentElement.nextElementSibling;
            while (fragment.firstChild) {
                insertAfter.insertAdjacentElement('afterend', fragment.firstChild);
                insertAfter = insertAfter.nextElementSibling;
            }
        }

        // Trigger animations with staggered delay
        childElements.forEach((element, index) => {
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.maxHeight = '30px';
            }, index * 20 + 10);
        });

        this.loadedPaths.add(parentPath);
    }

    getDepth(path) {
        // Calculate depth based on forward slashes, but handle root paths better
        if (!path || path === '/') return 0;
        const cleanPath = path.replace(/^\/+|\/+$/g, ''); // Remove leading/trailing slashes
        return cleanPath ? cleanPath.split('/').length - 1 : 0;
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
        const selectedCardsEl = el('selectedCards');

        const count = selected.size;

        if (selCountEl) selCountEl.textContent = count.toString();
        if (selCountTabEl) selCountTabEl.textContent = count.toString();

        // Update selection cards
        if (selectedCardsEl) {
            selectedCardsEl.innerHTML = '';

            if (count === 0) {
                selectedCardsEl.innerHTML = `
                    <div class="empty-selection-cards">
                        <i class="icon-empty"></i>
                        <p>No files selected</p>
                        <small>Use checkboxes in the explorer to select files and directories</small>
                    </div>
                `;
            } else {
                Array.from(selected).forEach(path => {
                    const card = this.createFileCard(path);
                    selectedCardsEl.appendChild(card);
                });
            }
        }

        // Estimate token count (rough approximation)
        const totalChars = Array.from(selected).join('\n').length;
        const tokens = Math.ceil(totalChars / 4);
        if (tokenCountEl) tokenCountEl.textContent = tokens.toString();
    }

    createFileCard(path) {
        const card = document.createElement('div');
        card.className = 'file-card';

        // Get file info
        const fileName = path.split('/').pop();
        const extension = getFileExtension(fileName);
        const isDirectory = this.isDirectory(path);

        card.dataset.type = isDirectory ? 'directory' : 'file';
        if (extension) {
            card.dataset.extension = extension;
        }

        // Get file stats (mock data for now - could be enhanced with real file stats)
        const stats = this.getFileStats(path);

        card.innerHTML = `
            <div class="file-card-header">
                <div class="file-card-icon">
                    ${isDirectory ? '📁' : getFileIcon(extension)}
                </div>
                <div class="file-card-info">
                    <h4 class="file-card-name">${fileName}</h4>
                    <p class="file-card-path">${path}</p>
                </div>
            </div>
            <div class="file-card-metadata">
                <div class="metadata-item">
                    <span class="icon">📄</span>
                    <span>${isDirectory ? 'Directory' : 'File'}</span>
                </div>
                ${extension ? `
                <div class="metadata-item">
                    <span class="icon">🏷️</span>
                    <span>${extension.toUpperCase()}</span>
                </div>
                ` : ''}
                <div class="metadata-item">
                    <span class="icon">📏</span>
                    <span>${stats.size}</span>
                </div>
                <div class="metadata-item">
                    <span class="icon">📅</span>
                    <span>${stats.modified}</span>
                </div>
            </div>
            <div class="file-card-actions">
                ${!isDirectory ? `
                <button class="card-btn card-btn-primary" onclick="fileTree.previewFileInModal('${path}')">
                    <i class="icon-file"></i>
                    Preview
                </button>
                ` : ''}
                <button class="card-btn card-btn-danger" onclick="fileTree.removeFromSelection('${path}')">
                    <i class="icon-close"></i>
                    Remove
                </button>
            </div>
        `;

        return card;
    }


    isDirectory(path) {
        // Check if path corresponds to a directory in the tree
        const treeItem = qs(`[data-path="${path}"]`);
        return treeItem && treeItem.dataset.type === 'directory';
    }

    getFileStats(path) {
        // Mock file stats - in a real implementation, this would come from the API
        return {
            size: formatFileSize(Math.floor(Math.random() * 100000) + 1000),
            modified: formatDate(new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000))
        };
    }

    async previewFileInModal(filePath) {
        // Create and show modal for file preview
        const modal = document.createElement('div');
        modal.className = 'modal fade file-preview-modal';
        modal.id = 'filePreviewModal';
        modal.innerHTML = `
            <div class="modal-dialog modal-xl">
                <div class="modal-content modal-content-dark">
                    <div class="modal-header modal-header-dark">
                        <div class="modal-title-container">
                            <h5 class="modal-title">${getFileIcon(getFileExtension(filePath.split('/').pop()))} ${filePath.split('/').pop()}</h5>
                            <span class="modal-subtitle">${filePath}</span>
                        </div>
                        <button type="button" class="btn-close btn-close-dark" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body modal-body-dark">
                        <div id="modalPreviewContent" class="code-preview-container">
                            <div class="loading">Loading file content...</div>
                        </div>
                    </div>
                    <div class="modal-footer modal-footer-dark">
                        <div class="file-info">
                            <span id="fileStats" class="file-stats"></span>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn btn-secondary btn-dark" data-bs-dismiss="modal">
                                <i class="icon-close"></i> Close
                            </button>
                            <button type="button" class="btn btn-primary" onclick="fileTree.copyModalContent()">
                                <i class="icon-copy"></i> Copy Content
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(modal);
        const bootstrapModal = new bootstrap.Modal(modal);
        bootstrapModal.show();

        // Load file content
        const r = await api(`/api/heroprompt/file?name=${currentWs}&path=${encodeURIComponent(filePath)}`);
        const contentEl = el('modalPreviewContent');

        if (r.error) {
            contentEl.innerHTML = `<div class="error-message">Error: ${r.error}</div>`;
        } else {
            const content = r.content || 'No content';
            this.renderCodePreview(contentEl, content, filePath);

            // Update file stats
            const statsEl = el('fileStats');
            if (statsEl) {
                const lines = content.split('\n').length;
                const chars = content.length;
                const words = content.split(/\s+/).filter(w => w.length > 0).length;
                statsEl.textContent = `${lines} lines, ${words} words, ${chars} characters`;
            }
        }

        // Clean up modal when closed
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }

    renderCodePreview(container, content, filePath) {
        const lines = content.split('\n');
        const extension = getFileExtension(filePath.split('/').pop());

        // Create the code preview structure with synchronized scrolling
        container.innerHTML = `
            <div class="code-scroll-container">
                <div class="line-numbers-container">
                    <div class="line-numbers-scroll">
                        ${lines.map((_, index) => `<div class="line-number">${index + 1}</div>`).join('')}
                    </div>
                </div>
                <div class="code-content-container">
                    <pre class="code-text" data-language="${extension}"><code>${this.escapeHtml(content)}</code></pre>
                </div>
            </div>
        `;

        // Set up synchronized scrolling
        this.setupSynchronizedScrolling(container);
    }

    setupSynchronizedScrolling(container) {
        const lineNumbersContainer = container.querySelector('.line-numbers-container');
        const codeContentContainer = container.querySelector('.code-content-container');
        const lineNumbersScroll = container.querySelector('.line-numbers-scroll');

        if (!lineNumbersContainer || !codeContentContainer || !lineNumbersScroll) {
            return;
        }

        // Synchronize scrolling between code content and line numbers
        codeContentContainer.addEventListener('scroll', () => {
            const scrollTop = codeContentContainer.scrollTop;
            lineNumbersContainer.scrollTop = scrollTop;
        });

        // Optional: Allow scrolling from line numbers to affect code content
        lineNumbersContainer.addEventListener('scroll', () => {
            const scrollTop = lineNumbersContainer.scrollTop;
            codeContentContainer.scrollTop = scrollTop;
        });

        // Ensure line numbers container can scroll
        lineNumbersContainer.style.overflow = 'hidden';
        lineNumbersContainer.style.height = '100%';

        // Make sure the line numbers scroll area matches the code content height
        const codeText = container.querySelector('.code-text');
        if (codeText) {
            const codeHeight = codeText.scrollHeight;
            lineNumbersScroll.style.height = `${codeHeight}px`;
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    copyModalContent() {
        const contentEl = el('modalPreviewContent');
        if (!contentEl) {
            console.warn('Modal content element not found');
            return;
        }

        const textContent = contentEl.textContent;
        if (!textContent || textContent.trim().length === 0) {
            console.warn('No content to copy');
            return;
        }

        if (!navigator.clipboard) {
            // Fallback for older browsers
            this.fallbackCopyToClipboard(textContent);
            return;
        }

        navigator.clipboard.writeText(textContent).then(() => {
            // Show success feedback
            const originalContent = contentEl.innerHTML;
            contentEl.innerHTML = '<div class="success-message">Content copied to clipboard!</div>';
            setTimeout(() => {
                contentEl.innerHTML = originalContent;
            }, 2000);
        }).catch(err => {
            console.error('Failed to copy content:', err);
            contentEl.innerHTML = '<div class="error-message">Failed to copy content</div>';
            setTimeout(() => {
                contentEl.innerHTML = originalContent;
            }, 2000);
        });
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
            console.log('Fallback: Content copied to clipboard');
        } catch (err) {
            console.error('Fallback: Failed to copy content', err);
        }

        document.body.removeChild(textArea);
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

    async search(query) {
        searchQuery = query.toLowerCase().trim();

        if (!searchQuery) {
            // Show all items when search is cleared
            qsa('.tree-item').forEach(item => {
                item.style.display = 'block';
            });
            return;
        }

        try {
            // Use the new search API to get all matching files across the workspace
            const searchResults = await api(`/api/heroprompt/workspaces/${encodeURIComponent(currentWs)}/search?q=${encodeURIComponent(searchQuery)}`);

            if (searchResults.error) {
                console.warn('Search failed:', searchResults.error);
                // Fallback to local search
                this.localSearch(query);
                return;
            }

            // Hide all current items
            qsa('.tree-item').forEach(item => {
                item.style.display = 'none';
            });

            // Show matching items and expand their parent directories
            const matchingPaths = new Set();
            searchResults.results.forEach(result => {
                matchingPaths.add(result.path);
                // Also add parent directory paths
                const pathParts = result.path.split('/');
                for (let i = 1; i < pathParts.length; i++) {
                    const parentPath = pathParts.slice(0, i).join('/');
                    if (parentPath) {
                        matchingPaths.add(parentPath);
                    }
                }
            });

            // Show items that match or are parents of matches
            // Get workspace info once
            const workspaceInfo = await api(`/api/heroprompt/workspaces/${currentWs}`);

            qsa('.tree-item').forEach(item => {
                const itemPath = item.dataset.path;
                if (itemPath) {
                    // Get relative path from workspace base
                    let relPath = itemPath;
                    if (workspaceInfo && workspaceInfo.base_path && itemPath.startsWith(workspaceInfo.base_path)) {
                        relPath = itemPath.substring(workspaceInfo.base_path.length);
                        if (relPath.startsWith('/')) {
                            relPath = relPath.substring(1);
                        }
                    }

                    if (matchingPaths.has(relPath) || relPath === '') {
                        item.style.display = 'block';
                        // Auto-expand directories that contain matches
                        if (item.dataset.type === 'directory' && !this.expandedDirs.has(itemPath)) {
                            this.toggleDirectory(itemPath);
                        }
                    }
                }
            });

        } catch (error) {
            console.warn('Search API error:', error);
            // Fallback to local search
            this.localSearch(query);
        }
    }

    localSearch(query) {
        const searchQuery = query.toLowerCase();
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

        if (r.error) {
            this.container.innerHTML = `<div class="error-message">${r.error}</div>`;
            return;
        }

        // Reset state
        this.loadedPaths.clear();
        this.expandedDirs.clear();
        expandedDirs.clear();

        // Sort items: directories first, then files
        const items = (r.items || []).sort((a, b) => {
            if (a.type !== b.type) {
                return a.type === 'directory' ? -1 : 1;
            }
            return a.name.localeCompare(b.name);
        });

        // Create document fragment for efficient DOM manipulation
        const fragment = document.createDocumentFragment();
        const elements = [];

        // Create all elements first
        for (const item of items) {
            const fullPath = workspacePath.endsWith('/') ?
                workspacePath + item.name :
                workspacePath + '/' + item.name;

            const element = this.createFileItem(item, fullPath, 0);
            element.style.opacity = '0';
            element.style.transform = 'translateY(-10px)';
            element.style.transition = 'opacity 0.3s ease, transform 0.3s ease';

            fragment.appendChild(element);
            elements.push(element);
        }

        // Clear container and add all elements at once
        this.container.innerHTML = '';
        this.container.appendChild(fragment);

        // Trigger staggered animations
        elements.forEach((element, i) => {
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, i * 50);
        });

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
    const promptTextEl = el('promptText');
    const outputEl = el('promptOutput');

    if (!outputEl) {
        console.error('Prompt output element not found');
        return;
    }

    if (!currentWs) {
        outputEl.innerHTML = '<div class="error-message">No workspace selected. Please select a workspace first.</div>';
        return;
    }

    if (selected.size === 0) {
        outputEl.innerHTML = '<div class="error-message">No files selected. Please select files first.</div>';
        return;
    }

    const promptText = promptTextEl?.value?.trim() || '';
    outputEl.innerHTML = '<div class="loading">Generating prompt...</div>';

    try {
        // sync selection to backend before generating
        const paths = Array.from(selected);
        const syncResult = await post(`/api/heroprompt/workspaces/${encodeURIComponent(currentWs)}/selection`, {
            paths: JSON.stringify(paths)
        });

        if (syncResult.error) {
            throw new Error(`Failed to sync selection: ${syncResult.error}`);
        }

        const r = await fetch(`/api/heroprompt/workspaces/${encodeURIComponent(currentWs)}/prompt`, {
            method: 'POST',
            body: new URLSearchParams({ text: promptText })
        });

        if (!r.ok) {
            throw new Error(`HTTP ${r.status}: ${r.statusText}`);
        }

        const result = await r.text();
        if (result.trim().length === 0) {
            outputEl.innerHTML = '<div class="error-message">Generated prompt is empty</div>';
        } else {
            outputEl.textContent = result;
        }
    } catch (e) {
        console.warn('Generate prompt failed', e);
        outputEl.innerHTML = `<div class="error-message">Failed to generate prompt: ${e.message}</div>`;
    }
}

async function copyPrompt() {
    const outputEl = el('promptOutput');
    if (!outputEl) {
        console.warn('Prompt output element not found');
        return;
    }

    const text = outputEl.textContent;
    if (!text || text.trim().length === 0 || text.includes('No files selected') || text.includes('Failed')) {
        console.warn('No valid content to copy');
        return;
    }

    if (!navigator.clipboard) {
        // Fallback for older browsers
        fallbackCopyToClipboard(text);
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
        const originalContent = outputEl.innerHTML;
        outputEl.innerHTML = '<div class="error-message">Failed to copy prompt</div>';
        setTimeout(() => {
            outputEl.innerHTML = originalContent;
        }, 2000);
    }
}

// Global fallback function for clipboard operations
function fallbackCopyToClipboard(text) {
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
        console.log('Fallback: Content copied to clipboard');
    } catch (err) {
        console.error('Fallback: Failed to copy content', err);
    }

    document.body.removeChild(textArea);
}

// Confirmation modal helper
function showConfirmationModal(message, onConfirm) {
    const messageEl = el('confirmDeleteMessage');
    const confirmBtn = el('confirmDeleteBtn');

    if (messageEl) messageEl.textContent = message;

    // Remove any existing event listeners
    const newConfirmBtn = confirmBtn.cloneNode(true);
    confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);

    // Add new event listener
    newConfirmBtn.addEventListener('click', () => {
        hideModal('confirmDeleteModal');
        onConfirm();
    });

    showModal('confirmDeleteModal');
}

// Workspace management functions
async function deleteWorkspace(workspaceName) {
    try {
        const encodedName = encodeURIComponent(workspaceName);
        const response = await fetch(`/api/heroprompt/workspaces/${encodedName}/delete`, {
            method: 'POST'
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error('Delete failed:', response.status, errorText);
            throw new Error(`HTTP ${response.status}: ${errorText}`);
        }

        // If we deleted the current workspace, switch to another one
        if (workspaceName === currentWs) {
            const names = await api('/api/heroprompt/workspaces');
            if (names && Array.isArray(names) && names.length > 0) {
                currentWs = names[0];
                localStorage.setItem('heroprompt-current-ws', currentWs);
                await reloadWorkspaces();
                const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
                const base = info?.base_path || '';
                if (base && fileTree) {
                    await fileTree.render(base);
                }
            }
        }

        return { success: true };
    } catch (e) {
        console.warn('Delete workspace failed', e);
        return { error: 'Failed to delete workspace' };
    }
}

async function updateWorkspace(workspaceName, newName, newPath) {
    try {
        const formData = new FormData();
        if (newName && newName !== workspaceName) {
            formData.append('name', newName);
        }
        if (newPath) {
            formData.append('base_path', newPath);
        }

        const encodedName = encodeURIComponent(workspaceName);
        const response = await fetch(`/api/heroprompt/workspaces/${encodedName}`, {
            method: 'PUT',
            body: formData
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error('Update failed:', response.status, errorText);
            throw new Error(`HTTP ${response.status}: ${errorText}`);
        }

        const result = await response.json();

        // Update current workspace if it was renamed
        if (workspaceName === currentWs && result.name && result.name !== workspaceName) {
            currentWs = result.name;
            localStorage.setItem('heroprompt-current-ws', currentWs);
        }

        await reloadWorkspaces();
        const info = await api(`/api/heroprompt/workspaces/${currentWs}`);
        const base = info?.base_path || '';
        if (base && fileTree) {
            await fileTree.render(base);
        }

        return result;
    } catch (e) {
        console.warn('Update workspace failed', e);
        return { error: 'Failed to update workspace' };
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

    // Workspace details update
    const wdUpdateBtn = el('wdUpdate');
    if (wdUpdateBtn) {
        wdUpdateBtn.addEventListener('click', async () => {
            const name = el('wdName')?.value?.trim() || '';
            const path = el('wdPath')?.value?.trim() || '';
            const errorEl = el('wdError');

            if (!path) {
                if (errorEl) errorEl.textContent = 'Path is required.';
                return;
            }

            const result = await updateWorkspace(currentWs, name, path);
            if (result.error) {
                if (errorEl) errorEl.textContent = result.error;
                return;
            }

            hideModal('wsDetails');
        });
    }

    // Workspace details delete
    const wdDeleteBtn = el('wdDelete');
    if (wdDeleteBtn) {
        wdDeleteBtn.addEventListener('click', async () => {
            showConfirmationModal(`Are you sure you want to delete workspace "${currentWs}"?`, async () => {
                const result = await deleteWorkspace(currentWs);
                if (result.error) {
                    const errorEl = el('wdError');
                    if (errorEl) errorEl.textContent = result.error;
                    return;
                }
                hideModal('wsDetails');
            });
        });
    }

    console.log('Enhanced HeroPrompt UI initialized');
});

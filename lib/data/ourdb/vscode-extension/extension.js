const vscode = require('vscode');
const fs = require('fs');

/**
 * Reads an OurDB record from a buffer at the given offset
 * @param {Buffer} buffer The file buffer
 * @param {number} offset The offset to read from
 * @returns {Object} The record data and next offset
 */
function readRecord(buffer, offset) {
    // Record format:
    // - 2 bytes: Data size (little-endian)
    // - 4 bytes: CRC32 checksum
    // - 6 bytes: Previous record location
    // - N bytes: Actual data
    
    // Read data size (first 2 bytes) in little-endian format
    const dataSize = buffer[offset] | (buffer[offset + 1] << 8);
    
    if (dataSize === 0 || offset + 12 + dataSize > buffer.length) {
        throw new Error('Invalid record or end of file');
    }
    
    // Extract the data portion
    const data = buffer.slice(offset + 12, offset + 12 + dataSize);
    
    return {
        size: dataSize,
        data: data.toString(), // Assuming UTF-8 data
        nextOffset: offset + 12 + dataSize
    };
}

/**
 * Parse an OurDB file and return its contents as formatted text
 * @param {string} filePath Path to the OurDB file
 * @returns {string} Formatted content
 */
function parseOurDBFile(filePath) {
    try {
        // Check if file exists
        if (!fs.existsSync(filePath)) {
            return `Error: File not found at ${filePath}`;
        }
        
        // Get file stats
        const stats = fs.statSync(filePath);
        if (stats.size === 0) {
            return 'Error: File is empty';
        }
        
        const buffer = fs.readFileSync(filePath);
        
        let content = [];
        content.push(`# OurDB File: ${filePath}`);
        content.push(`# File size: ${stats.size} bytes`);
        content.push(`# Last modified: ${stats.mtime.toLocaleString()}`);
        content.push('');
        
        let offset = 0;
        let id = 1;
        let recordsRead = 0;
        let errorCount = 0;

        // Read records until we reach the end of file
        while (offset < buffer.length) {
            try {
                const record = readRecord(buffer, offset);
                
                // Try to parse as JSON if it looks like JSON
                let displayData = record.data;
                if (record.data.trim().startsWith('{') || record.data.trim().startsWith('[')) {
                    try {
                        const jsonObj = JSON.parse(record.data);
                        displayData = JSON.stringify(jsonObj, null, 2);
                    } catch (jsonErr) {
                        // Not valid JSON, use as-is
                    }
                }
                
                content.push(`Record ${id} (size: ${record.size} bytes):`);
                content.push('```');
                content.push(displayData);
                content.push('```');
                content.push('');
                
                offset = record.nextOffset;
                id++;
                recordsRead++;
            } catch (e) {
                errorCount++;
                if (errorCount === 1) {
                    // Only show the first error
                    content.push(`Error reading record at offset ${offset}: ${e.message}`);
                }
                // Skip ahead to try to find next valid record
                offset += 1;
                
                // If we've had too many errors in a row, stop trying
                if (errorCount > 10 && recordsRead === 0) {
                    content.push('Too many errors encountered. This may not be a valid OurDB file.');
                    break;
                }
            }
        }
        
        if (recordsRead === 0) {
            content.push('No valid records found in this file.');
        } else {
            content.push(`Total records: ${recordsRead}`);
        }

        return content.join('\n');
    } catch (error) {
        return `Error reading OurDB file: ${error.message}\n${error.stack}`;
    }
}

/**
 * Content provider for the ourdb:// scheme
 */
class OurDBContentProvider {
    constructor() {
        this._onDidChange = new vscode.EventEmitter();
        this.onDidChange = this._onDidChange.event;
    }

    provideTextDocumentContent(uri) {
        return parseOurDBFile(uri.fsPath);
    }
}

/**
 * Custom document for OurDB files
 */
class OurDBDocument {
    constructor(uri) {
        this.uri = uri;
    }

    dispose() {
        // Nothing to dispose
    }
}

/**
 * Custom editor provider for .ourdb files
 */
class OurDBEditorProvider {
    constructor(outputChannel) {
        this.outputChannel = outputChannel;
    }
    
    // Required method for custom editors
    async openCustomDocument(uri, _openContext, _token) {
        this.outputChannel.appendLine(`Opening custom document for: ${uri.fsPath}`);
        return new OurDBDocument(uri);
    }

    // Required method for custom editors
    resolveCustomEditor(document, webviewPanel, _token) {
        this.outputChannel.appendLine(`Custom editor resolving for: ${document.uri.fsPath}`);
        
        try {
            const content = parseOurDBFile(document.uri.fsPath);
            
            // Set the HTML content for the webview
            webviewPanel.webview.options = {
                enableScripts: false
            };
            
            webviewPanel.webview.html = this.getHtmlForWebview(content);
            this.outputChannel.appendLine('Custom editor content set');
        } catch (error) {
            this.outputChannel.appendLine(`Error in resolveCustomEditor: ${error.message}`);
            this.outputChannel.appendLine(error.stack);
            
            webviewPanel.webview.html = `<html><body>
                <h1>Error</h1>
                <pre>${error.message}\n${error.stack}</pre>
            </body></html>`;
        }
    }
    
    getHtmlForWebview(content) {
        // Convert the content to HTML with syntax highlighting
        const htmlContent = content
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/```([\s\S]*?)```/g, (match, code) => {
                return `<pre class="code-block">${code}</pre>`;
            })
            .replace(/^# (.*?)$/gm, '<h1>$1</h1>')
            .replace(/\n/g, '<br>');
        
        return `<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>OurDB Viewer</title>
            <style>
                body {
                    font-family: var(--vscode-editor-font-family);
                    font-size: var(--vscode-editor-font-size);
                    padding: 0 20px;
                    color: var(--vscode-editor-foreground);
                    background-color: var(--vscode-editor-background);
                }
                h1 {
                    font-size: 1.2em;
                    margin-top: 20px;
                    margin-bottom: 10px;
                    color: var(--vscode-editorLink-activeForeground);
                }
                .code-block {
                    background-color: var(--vscode-textCodeBlock-background);
                    padding: 10px;
                    border-radius: 3px;
                    font-family: var(--vscode-editor-font-family);
                    white-space: pre-wrap;
                    margin: 10px 0;
                }
            </style>
        </head>
        <body>
            ${htmlContent}
        </body>
        </html>`;
    }
}

function activate(context) {
    // Create output channel for logging
    const outputChannel = vscode.window.createOutputChannel('OurDB Viewer');
    outputChannel.appendLine('OurDB extension activated');
    outputChannel.show(true);
    
    // Register our custom content provider for the ourdb:// scheme
    const contentProvider = new OurDBContentProvider();
    const contentProviderRegistration = vscode.workspace.registerTextDocumentContentProvider('ourdb', contentProvider);

    // Register our custom editor provider
    const editorProvider = new OurDBEditorProvider(outputChannel);
    const editorRegistration = vscode.window.registerCustomEditorProvider(
        'ourdb.viewer',
        editorProvider,
        {
            webviewOptions: { retainContextWhenHidden: true },
            supportsMultipleEditorsPerDocument: false
        }
    );

    // Register a command to refresh the view
    const refreshCommand = vscode.commands.registerCommand('ourdb.refresh', () => {
        contentProvider._onDidChange.fire(vscode.window.activeTextEditor?.document.uri);
    });
    
    // Register a command to open .ourdb files
    const openOurDBCommand = vscode.commands.registerCommand('ourdb.openFile', (uri) => {
        try {
            if (!uri) {
                outputChannel.appendLine('URI is undefined in openOurDBCommand');
                return;
            }
            
            outputChannel.appendLine(`Command triggered for: ${uri.fsPath}`);
            
            // Open with the custom editor
            vscode.commands.executeCommand('vscode.openWith', uri, 'ourdb.viewer');
            outputChannel.appendLine('Opened with custom editor via command');
        } catch (error) {
            outputChannel.appendLine(`Error in openOurDBCommand: ${error.message}`);
            outputChannel.appendLine(error.stack);
        }
    });
    
    // Register a file open handler for .ourdb files
    const fileOpenHandler = vscode.workspace.onDidOpenTextDocument(document => {
        try {
            // More robust check for document and uri properties
            if (!document || !document.uri) {
                outputChannel.appendLine('Document or URI is undefined');
                return;
            }
            
            outputChannel.appendLine(`File opened: ${document.uri.fsPath} (scheme: ${document.uri.scheme})`);
            outputChannel.appendLine(`Language ID: ${document.languageId}, Is binary: ${document.isClosed}`);
            
            // Check if uri has necessary properties
            if (typeof document.uri.fsPath !== 'string') {
                outputChannel.appendLine('File path is not a string');
                return;
            }
            
            // Check if this is an .ourdb file
            if (!document.uri.fsPath.endsWith('.ourdb')) {
                outputChannel.appendLine(`Skipping non-ourdb file: ${document.uri.fsPath}`);
                return;
            }
            
            // Ensure uri has a scheme property before using with()
            if (typeof document.uri.scheme !== 'string') {
                outputChannel.appendLine('Warning: document.uri.scheme is not defined');
                return;
            }
            
            // Skip if already using our custom scheme
            if (document.uri.scheme === 'ourdb') {
                outputChannel.appendLine('Already using ourdb scheme, skipping');
                return;
            }
            
            outputChannel.appendLine(`Processing .ourdb file: ${document.uri.fsPath}`);
            
            // Open with the custom editor
            vscode.commands.executeCommand('vscode.openWith', document.uri, 'ourdb.viewer');
            outputChannel.appendLine('Opened with custom editor');
        } catch (error) {
            outputChannel.appendLine(`Error in fileOpenHandler: ${error.message}`);
            outputChannel.appendLine(error.stack);
        }
    });
    
    // Register a file system watcher for .ourdb files
    const watcher = vscode.workspace.createFileSystemWatcher('**/*.ourdb');
    
    watcher.onDidCreate((uri) => {
        outputChannel.appendLine(`OurDB file created: ${uri.fsPath}`);
        vscode.commands.executeCommand('ourdb.openFile', uri);
    });
    
    watcher.onDidChange((uri) => {
        outputChannel.appendLine(`OurDB file changed: ${uri.fsPath}`);
        if (vscode.window.activeTextEditor && 
            vscode.window.activeTextEditor.document.uri.fsPath === uri.fsPath) {
            vscode.commands.executeCommand('ourdb.refresh');
        }
    });

    // Add all disposables to subscriptions
    context.subscriptions.push(
        contentProviderRegistration,
        editorRegistration,
        refreshCommand,
        openOurDBCommand,
        fileOpenHandler,
        watcher,
        outputChannel
    );
}

function deactivate() {}

module.exports = {
    activate,
    deactivate
};

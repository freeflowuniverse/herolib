#!/bin/bash

# Exit on error
set -e

echo "Starting HeroLib Manual Wiki Server..."

# Get the directory of this script (manual directory)
MANUAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the wiki package
WIKI_DIR="/Users/timurgordon/code/github/freeflowuniverse/herolauncher/pkg/ui/wiki"

# Path to the herolib directory
HEROLIB_DIR="/Users/timurgordon/code/github/freeflowuniverse/herolib"

# Check if the wiki directory exists
if [ ! -d "$WIKI_DIR" ]; then
  echo "Error: Wiki directory not found at $WIKI_DIR"
  exit 1
fi

# Check if the herolib directory exists
if [ ! -d "$HEROLIB_DIR" ]; then
  echo "Error: HeroLib directory not found at $HEROLIB_DIR"
  exit 1
fi

# Create a local VFS instance for the manual directory
echo "Creating local VFS for manual directory: $MANUAL_DIR"
cd "$HEROLIB_DIR"

# Create a temporary V program to initialize the VFS
TMP_DIR=$(mktemp -d)
VFS_INIT_FILE="$TMP_DIR/vfs_init.v"

cat > "$VFS_INIT_FILE" << 'EOL'
module main

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.vfs.vfs_local
import os

fn main() {
    if os.args.len < 2 {
        println('Usage: vfs_init <root_path>')
        exit(1)
    }
    
    root_path := os.args[1]
    println('Initializing local VFS with root path: ${root_path}')
    
    vfs_impl := vfs_local.new_local_vfs(root_path) or {
        println('Error creating local VFS: ${err}')
        exit(1)
    }
    
    println('Local VFS initialized successfully')
}
EOL

# Compile and run the VFS initialization program
cd "$TMP_DIR"
v "$VFS_INIT_FILE"
"$TMP_DIR/vfs_init" "$MANUAL_DIR"

# Generate configuration JSON file with sidebar data
CONFIG_FILE="$TMP_DIR/wiki_config.json"
echo "Generating wiki configuration file: $CONFIG_FILE"

# Create a temporary Go program to generate the sidebar configuration
SIDEBAR_GEN_FILE="$TMP_DIR/sidebar_gen.go"

cat > "$SIDEBAR_GEN_FILE" << 'EOL'
package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

// SidebarItem represents an item in the sidebar
type SidebarItem struct {
	Title    string        `json:"Title"`
	Href     string        `json:"Href"`
	IsDir    bool          `json:"IsDir"`
	External bool          `json:"External,omitempty"`
	Children []SidebarItem `json:"Children,omitempty"`
}

// SidebarSection represents a section in the sidebar
type SidebarSection struct {
	Title string        `json:"Title"`
	Items []SidebarItem `json:"Items"`
}

// Configuration represents the wiki configuration
type Configuration struct {
	Sidebar []SidebarSection `json:"Sidebar"`
	Title   string           `json:"Title,omitempty"`
	BaseURL string           `json:"BaseURL,omitempty"`
}

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: sidebar_gen <content_path> <output_file>")
		os.Exit(1)
	}

	contentPath := os.Args[1]
	outputFile := os.Args[2]

	// Generate sidebar data
	sidebar, err := generateSidebarFromPath(contentPath)
	if err != nil {
		fmt.Printf("Error generating sidebar: %v\n", err)
		os.Exit(1)
	}

	// Create configuration
	config := Configuration{
		Sidebar: sidebar,
		Title:   "HeroLib Manual",
	}

	// Write to file
	configJSON, err := json.MarshalIndent(config, "", "  ")
	if err != nil {
		fmt.Printf("Error marshaling JSON: %v\n", err)
		os.Exit(1)
	}

	err = ioutil.WriteFile(outputFile, configJSON, 0644)
	if err != nil {
		fmt.Printf("Error writing file: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Configuration written to %s\n", outputFile)
}

// Generate sidebar data from content path
func generateSidebarFromPath(contentPath string) ([]SidebarSection, error) {
	// Get absolute path for content directory
	absContentPath, err := filepath.Abs(contentPath)
	if err != nil {
		return nil, fmt.Errorf("error getting absolute path: %w", err)
	}

	// Process top-level directories and files
	dirs, err := ioutil.ReadDir(absContentPath)
	if err != nil {
		return nil, fmt.Errorf("error reading content directory: %w", err)
	}

	// Create sections for each top-level directory
	var sections []SidebarSection

	// Add files at the root level to a "General" section
	var rootFiles []SidebarItem

	// Process directories and files
	for _, dir := range dirs {
		if dir.IsDir() {
			// Process directory
			dirPath := filepath.Join(absContentPath, dir.Name())
			// Pass the top-level directory name as the initial parent path
			items, err := processDirectoryHierarchy(dirPath, absContentPath, dir.Name())
			if err != nil {
				return nil, fmt.Errorf("error processing directory %s: %w", dir.Name(), err)
			}

			if len(items) > 0 {
				sections = append(sections, SidebarSection{
					Title: formatTitle(dir.Name()),
					Items: items,
				})
			}
		} else if isMarkdownFile(dir.Name()) {
			// Add root level markdown files to the General section
			filePath := filepath.Join(absContentPath, dir.Name())
			fileItem := createSidebarItemFromFile(filePath, absContentPath, "")
			rootFiles = append(rootFiles, fileItem)
		}
	}

	// Add root files to a General section if there are any
	if len(rootFiles) > 0 {
		sections = append([]SidebarSection{{
			Title: "General",
			Items: rootFiles,
		}}, sections...)
	}

	return sections, nil
}

// Process a directory and return a hierarchical structure of sidebar items
func processDirectoryHierarchy(dirPath, rootPath, parentPath string) ([]SidebarItem, error) {
	entries, err := ioutil.ReadDir(dirPath)
	if err != nil {
		return nil, fmt.Errorf("error reading directory %s: %w", dirPath, err)
	}

	var items []SidebarItem

	// Process all entries in the directory
	for _, entry := range entries {
		entryPath := filepath.Join(dirPath, entry.Name())
		relPath := filepath.Join(parentPath, entry.Name())

		if entry.IsDir() {
			// Process subdirectory
			subItems, err := processDirectoryHierarchy(entryPath, rootPath, relPath)
			if err != nil {
				return nil, err
			}

			if len(subItems) > 0 {
				// Create a directory item with children
				items = append(items, SidebarItem{
					Title:    formatTitle(entry.Name()),
					Href:     "/" + relPath, // Add leading slash
					IsDir:    true,
					Children: subItems,
				})
			}
		} else if isMarkdownFile(entry.Name()) {
			// Process markdown file
			fileItem := createSidebarItemFromFile(entryPath, rootPath, parentPath)
			items = append(items, fileItem)
		}
	}

	return items, nil
}

// Create a sidebar item from a file path
func createSidebarItemFromFile(filePath, rootPath, parentPath string) SidebarItem {
	fileName := filepath.Base(filePath)
	baseName := strings.TrimSuffix(fileName, filepath.Ext(fileName))
	relPath := filepath.Join(parentPath, baseName)

	return SidebarItem{
		Title: formatTitle(baseName),
		Href:  "/" + relPath, // Add leading slash for proper URL formatting
		IsDir: false,
	}
}

// Format a title from a file or directory name
func formatTitle(name string) string {
	// Replace underscores and hyphens with spaces
	name = strings.ReplaceAll(name, "_", " ")
	name = strings.ReplaceAll(name, "-", " ")

	// Capitalize the first letter of each word
	words := strings.Fields(name)
	for i, word := range words {
		if len(word) > 0 {
			words[i] = strings.ToUpper(word[0:1]) + word[1:]
		}
	}

	return strings.Join(words, " ")
}

// Check if a file is a markdown file
func isMarkdownFile(fileName string) bool {
	ext := strings.ToLower(filepath.Ext(fileName))
	return ext == ".md" || ext == ".markdown"
}
EOL

# Compile and run the sidebar generator
cd "$TMP_DIR"
go build -o sidebar_gen "$SIDEBAR_GEN_FILE"
"$TMP_DIR/sidebar_gen" "$MANUAL_DIR" "$CONFIG_FILE"

# Start the wiki server with the manual directory as the content path and config file
echo "Serving manual content from: $MANUAL_DIR"
echo "Using wiki server from: $WIKI_DIR"
cd "$WIKI_DIR"

# Display the generated configuration for debugging
echo "Generated configuration:"
cat "$CONFIG_FILE" | head -n 30

# Run the wiki server on port 3004
go run main.go "$MANUAL_DIR" "$CONFIG_FILE" 3004

# The script will not reach this point unless the server is stopped
echo "Wiki server stopped."

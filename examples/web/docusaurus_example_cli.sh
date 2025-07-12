#!/bin/bash

# Exit script on any error
set -e

echo "Starting Docusaurus Example with Hero CLI"

# Define the source directory for the Docusaurus site content
# Using a different name (_cli) to avoid conflicts with the previous example
SOURCE_DIR="${HOME}/hero/var/docusaurus_demo_src_cli"
DOCS_SUBDIR="${SOURCE_DIR}/docs"

# Create the site source directory and the docs subdirectory if they don't exist
echo "Creating site source directory: ${SOURCE_DIR}"
mkdir -p "${DOCS_SUBDIR}"

# --- Create Sample Markdown Content ---
# The 'hero docusaurus' command doesn't automatically create content,
# so we do it here like the V example script did.

echo "Creating sample markdown content..."

# Create intro.md
# Using 'EOF' to prevent shell expansion within the heredoc
cat > "${DOCS_SUBDIR}/intro.md" << 'EOF'
---
title: Introduction (CLI Example)
slug: /
sidebar_position: 1
---

# Welcome to My Documentation (CLI Version)

This is a sample documentation site created with Docusaurus and HeroLib V using the `hero docusaurus` command and a HeroScript configuration file.

## Features

- Easy to use
- Markdown support
- Customizable
- Search functionality

## Getting Started

Follow these steps to get started:

1. Installation
2. Configuration
3. Adding content
4. Deployment
EOF

# Create quick-start.md
cat > "${DOCS_SUBDIR}/quick-start.md" << 'EOF'
---
title: Quick Start (CLI Example)
sidebar_position: 2
---

# Quick Start Guide (CLI Version)

This guide will help you get up and running quickly.

## Installation

```bash
$ npm install my-project
```

## Basic Usage

```javascript
import { myFunction } from "my-project";

// Use the function
const result = myFunction();
console.log(result);
```
EOF

echo "Sample markdown content created."


# --- Run Docusaurus Directly via V Script ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# -n initializes the site structure if it doesn't exist (--new)
# -d runs the development server (--dev)
hero docusaurus -buildpath "${HOME}/hero/var/docusaurus_demo_src_cli" -path "${SCRIPT_DIR}/cfg/docusaurus_example_config.heroscript" -new -dev

echo "Hero docusaurus command finished. Check for errors or dev server output."

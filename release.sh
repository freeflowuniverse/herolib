#!/bin/bash
set -e

# Function to get the latest release tag
get_latest_release() {
    curl --silent "https://api.github.com/repos/freeflowuniverse/herolib/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Show current version
echo "Current latest release: $(get_latest_release)"

# Ask for new version
read -p "Enter new version (e.g., 1.0.4): " new_version

# Validate version format
if [[ ! $new_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 1.0.4)"
    exit 1
fi

# Update version in hero.v
sed -i.bak "s/version:     '[0-9]\+\.[0-9]\+\.[0-9]\+'/version:     '$new_version'/" cli/hero.v
rm -f cli/hero.v.bak

# Commit changes
git add . -A
git commit -m "chore: bump version to $new_version"
git pull
git push

# Create and push tag
git tag -a "v$new_version" -m "Release version $new_version"
git push origin "v$new_version"

echo "Release v$new_version created and pushed!"

#!/bin/bash

# Map your repo folders to their corresponding system folders
declare -A folder_mapping=(
    ["/config"]="~/.config"
    ["/local"]="~/.local"
)

# Dotfiles repository location
DOTFILES_DIR=~/dotfiles

# Iterate through the folder mapping
for source in "${!folder_mapping[@]}"; do
    dest=${folder_mapping[$source]}
    dest=${dest/#\~/$HOME} # Replace ~ with the home directory

    # Find all files in the source folder
    find "$DOTFILES_DIR$source" -type f | while read -r file; do
        # Determine the relative path in the repo
        relative_path=${file#$DOTFILES_DIR$source/}

        # Determine the full destination path
        dest_path="$dest/$relative_path"

        # Ensure the parent directory exists
        mkdir -p "$(dirname "$dest_path")"

        # If the file exists, create a backup
        if [ -e "$dest_path" ] && [ ! -L "$dest_path" ]; then
            echo "Backing up existing config: $dest_path -> $dest_path.bak"
            cp "$dest_path" "$dest_path.bak"
        fi

        # Create the symbolic link
        echo "Linking $file to $dest_path"
        ln -sf "$file" "$dest_path"
    done
done

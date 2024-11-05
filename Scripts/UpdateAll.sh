#!/bin/bash

# Parse command line arguments
NO_AUR=false
for arg in "$@"; do
    if [[ "$arg" == "--no-aur" ]]; then
        NO_AUR=true
        break
    fi
done

# Update the official repositories
echo "Updating system repositories..."
sudo pacman -Syu --noconfirm

# If --no-aur flag is set, skip AUR updates and exit
if $NO_AUR; then
    echo "Skipping AUR updates due to --no-aur flag."
    exit 0
fi

# Directory where your AUR packages are stored
AUR_DIR="$HOME/AUR-Packages"

# Check if the directory exists
if [ ! -d "$AUR_DIR" ]; then
    echo "AUR directory $AUR_DIR does not exist. Please update the script with the correct path."
    exit 1
fi

# Loop through each subdirectory (assumed to be AUR packages)
echo "Updating AUR packages..."
for dir in "$AUR_DIR"/*; do
    if [ -d "$dir" ]; then
        echo "Updating $(basename "$dir")..."
        cd "$dir" || continue

        ## Pull the latest changes from the AUR repository
        git_output=$(git pull --ff-only)
        
        # If no updates, skip building
        if [[ "$git_output" == "Already up to date." ]]; then
            echo "$(basename "$dir") is already up to date, skipping..."
            cd "$AUR_DIR" || exit
            continue
        fi

        # Make the package: resolve dependencies, install the package, and clean up afterward
        makepkg -sirc --noconfirm

        # Optional: Use git clean to remove untracked files after building
        git clean -dfx

        # Install the built package manually with pacman -U
        PACKAGE_FILE=$(ls -t *.pkg.tar.zst | head -n 1)
        if [ -n "$PACKAGE_FILE" ]; then
            echo "Installing $PACKAGE_FILE..."
            sudo pacman -U "$PACKAGE_FILE" --noconfirm
        else
            echo "No package file found for $(basename "$dir")"
        fi

        # Return to the AUR directory
        cd "$AUR_DIR" || exit
    fi
done

echo "System and AUR updates complete!"
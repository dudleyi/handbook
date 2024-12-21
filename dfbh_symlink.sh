#!/bin/sh

# prep it by doing: chmod +x dfbh_symlink.sh

# run it by doing: ./dfbh_symlink.sh

# Define the target symlink path and source handbook directory
HANDBOOK_SYMLINK="$HOME/handbook"
HANDBOOK_SOURCE="/usr/share/doc/handbook"

# Check if the symlink already exists and is valid
if [ -L "$HANDBOOK_SYMLINK" ]; then
    if [ "$(readlink "$HANDBOOK_SYMLINK")" = "$HANDBOOK_SOURCE" ]; then
        echo "Symlink already exists and is correct: $HANDBOOK_SYMLINK -> $HANDBOOK_SOURCE"
        exit 0
    else
        echo "Symlink exists but points elsewhere. Recreating..."
        rm "$HANDBOOK_SYMLINK"
    fi
elif [ -e "$HANDBOOK_SYMLINK" ]; then
    echo "$HANDBOOK_SYMLINK exists but is not a symlink. Please remove it manually."
    exit 1
fi

# Check if the source directory exists
if [ -d "$HANDBOOK_SOURCE" ]; then
    echo "Creating symlink: $HANDBOOK_SYMLINK -> $HANDBOOK_SOURCE"
    ln -s "$HANDBOOK_SOURCE" "$HANDBOOK_SYMLINK"
    echo "Symlink created successfully."
else
    echo "Error: $HANDBOOK_SOURCE does not exist. Please ensure the FreeBSD Handbook is installed."
    exit 1
fi

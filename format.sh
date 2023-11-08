#!/usr/bin/env sh

# Get the current hostname
HOSTNAME=$(hostname)

# Logging the initial action
echo "Switching to script directory..."

# Push the current directory onto the stack and change to the directory of this script
pushd "$(dirname "$0")" > /dev/null

# Find all .nix files in the current directory and subdirectories
# and format them with nix fmt 
find . -name "*.nix" -exec nix fmt {} \;

# Log the directory switch-back action
echo "Returning to the original directory..."

# Return to the original directory by popping it off the stack
popd > /dev/null

# Logging completion
echo "Done!"

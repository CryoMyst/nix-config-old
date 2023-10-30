#!/usr/bin/env sh

# Get the current hostname
HOSTNAME=$(hostname)

# Logging the initial action
echo "Switching to script directory..."

# Push the current directory onto the stack and change to the directory of this script
pushd "$(dirname "$0")" > /dev/null

# If --update is given run nix flake update
# Check if --update is given as a parameter
for arg in "$@"; do
    if [ "$arg" = "--update" ]; then
        echo "Updating flake..."
        nix flake update
        break
    fi
done

# Log the nixos-rebuild build action
echo "Checking configuration with nixos-rebuild build for hostname: ${HOSTNAME}..."

# Run the nixos-rebuild build command with the current hostname using sudo
sudo nixos-rebuild --flake ".#${HOSTNAME}" build --show-trace

# If the build was successful, ask for confirmation to apply
if [ $? -eq 0 ]; then
    echo "Configuration build was successful."
    echo -n "Do you want to apply this configuration? (y/n) "
    read CONFIRM
    if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
        # Run the nixos-rebuild switch command
        echo "Applying configuration..."
        sudo nixos-rebuild --flake ".#${HOSTNAME}" switch
    else
        echo "Configuration not applied."
    fi
else
    echo "Configuration build failed. Please check your configuration."
fi

# Log the directory switch-back action
echo "Returning to the original directory..."

# Return to the original directory by popping it off the stack
popd > /dev/null

# Logging completion
echo "Done!"

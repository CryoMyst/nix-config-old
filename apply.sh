#!/usr/bin/env sh

# Get the current hostname
HOSTNAME=$(hostname)
# --update 
# Determines if we should run nix flake update
UPDATE=0
# --accept
# Skips the confirmation prompt
ACCEPT=0

function setup_flags() {
    for arg in "$@"; do
        if [ "$arg" = "--update" ]; then
            echo "Update flag detected."
            UPDATE=1
        fi
        if [ "$arg" = "--accept" ]; then
            echo "Accept flag detected."
            ACCEPT=1
        fi
    done
}

function push_flake_directory() {
    echo "Switching to script directory..."
    # Push the current directory onto the stack and change to the directory of this script
    pushd "$(dirname "$0")" > /dev/null
}

function restore_directory() {
    # Return to the original directory by popping it off the stack
    popd > /dev/null
}

function update_flake() {
    echo "Updating flake..."
    time nix flake update
    echo "Flake update was successful."
}

function build_flake() {
    echo "Checking configuration with nixos-rebuild build for hostname: ${HOSTNAME}..."
    time sudo nixos-rebuild --impure --flake ".#${HOSTNAME}" build --show-trace
    echo "Configuration build was successful."
}

function apply_flake() {
    echo "Applying configuration..."
    time sudo nixos-rebuild --impure --flake ".#${HOSTNAME}" switch
}

function prompt_user() {
    prompt_text=$1
    # If the --accept flag was passed, skip the confirmation prompt
    if [ $ACCEPT -eq 1 ]; then
        echo "Accept flag detected. Skipping confirmation prompt."
        return 1
    fi
    # If the prompt text is empty, use the default prompt
    if [ -z "$prompt_text" ]; then
        prompt_text="Are you sure? (y/n) "
    fi
    echo -n "$prompt_text"
    read CONFIRM
    if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
        return 1
    else
        return 0
    fi
}

function run() {
    setup_flags "$@"

    # Log the directory switch action
    push_flake_directory

    # Log the nix flake update action
    if [ $UPDATE -eq 1 ]; then
        update_flake
    fi

    # Log the nixos-rebuild build action
    build_flake

    if [ $? -ne 0 ]; then
        echo "Configuration build failed. Please check your configuration."
        restore_directory
        exit 1
    fi

    prompt_user "Would you like to apply the configuration? (y/n) "
    if [ $? -eq 1 ]; then
        apply_flake
    fi

    restore_directory
    exit 0
}

run "$@"



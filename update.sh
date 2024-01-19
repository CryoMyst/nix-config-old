#!/usr/bin/env sh

function setup_parameters() {
    for arg in "$@"; do
        echo "Unknown flag detected: $arg"
        exit_error "Unknown flag detected."
    done
}

function exit_error() {
    echo "Error: $1"
    exit 1
}

function push_flake_directory() {
    # Push the current directory onto the stack and change to the directory of this script
    echo "Switching to script directory..."
    pushd "$(dirname "$0")" > /dev/null
}

function restore_directory() {
    # Return to the original directory by popping it off the stack
    popd > /dev/null
}

function update_all() {
    nix flake lock --update-all
}

function update_inputs() {
    nix flake lock --update-input "$1"
}

function get_inputs() {
    nix flake metadata --json | nix run nixpkgs#jq '.locks.nodes.root' | nix run nixpkgs#jq '.inputs' | nix run nixpkgs#jq 'keys' | nix run nixpkgs#jq '.[]' | sed 's/"//g'
}

function prompt_list() {
    local prompt="$1"
    local default="$3"
    local options="$2 $default"
    local result=""

    echo "$prompt"
    select opt in $options; do
        result="$opt"
        break
    done

    SELECTED_PROMPT="$result"
}

function run() {
    setup_parameters "$@"

    # Log the directory switch action
    push_flake_directory

    # Update all inputs
    local options=("All Input Clean")
    prompt_list "Select an option:" "$options" "Cancel"
    if [ "$SELECTED_PROMPT" = "Cancel" ]; then
        echo "Cancelled."
    elif [ "$SELECTED_PROMPT" = "All" ]; then
        echo "Updating all inputs..."
        update_all
    elif [ "$SELECTED_PROMPT" = "Input" ]; then
        # Get the list of inputs
        local inputs=$(get_inputs)
        inputs="All $inputs"
        prompt_list "Select an input to update:" "$inputs" "Cancel"
        local input="$SELECTED_PROMPT"

        echo "Updating input: $input"
        update_inputs "$input"
    elif [ "$SELECTED_PROMPT" = "Clean" ]; then
        echo "Cleaning flake..."
    else
        echo "Unknown option: $SELECTED_PROMPT"
        exit_error "Unknown option."
    fi

    restore_directory
    exit 0
}

run "$@"
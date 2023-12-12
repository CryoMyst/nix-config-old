{ pkgs, ... }:
with pkgs; [
  # Tools
  vscode
  # gitkraken

  # Should only be used sparingly, not all IDEs work well with nix when installed this way
  # jetbrains-toolbox

  # JetBrains IDEs
  # jetbrains.pycharm-professional
  # jetbrains.rider
  # jetbrains.clion
  # jetbrains.webstorm
  # jetbrains.goland
  # jetbrains.idea-ultimate
  # jetbrains.datagrip
  # jetbrains.rust-rover
]

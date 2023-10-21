{ pkgs, ... }:
with pkgs; [
  # Toolchains
  gcc
  rustup
  dotnet-sdk_8

  # Tools
  vscode
  gitkraken
  jetbrains-toolbox
]
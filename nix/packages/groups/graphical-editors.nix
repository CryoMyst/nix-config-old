{ pkgs, ... }:
let
  system = pkgs.system;

  
  jetbrainsProducts = with pkgs; [
    # JetBrains IDEs
    jetbrains.pycharm-professional
    jetbrains.clion
    jetbrains.webstorm
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.datagrip
    jetbrains.rust-rover
  ];

  x86JetbrainsProducts = with pkgs; [
    jetbrains.rider
  ];

  x86Tools = with pkgs; [
    gitkraken
  ];

  tools = with pkgs; [
    vscode
  ];

in
  if system == "x86_64-linux" then
    tools 
      ++ x86Tools
      ++ jetbrainsProducts
      ++ x86JetbrainsProducts
  else
    tools
      ++ jetbrainsProducts

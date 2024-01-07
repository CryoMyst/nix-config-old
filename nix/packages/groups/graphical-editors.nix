{ pkgs, ... }:
let
  system = pkgs.system;

  # Common plugins for all JetBrains products
  commonPlugins = ["github-copilot"];

  # Function to add plugins to a JetBrains product
  addPluginsToJetBrainsProduct = product: specificPlugins: 
    pkgs.jetbrains.plugins.addPlugins product (commonPlugins ++ specificPlugins);

  jetbrainsProducts = with pkgs; [
    # Apply common plugins and specific plugins (if any) to each JetBrains IDE
    (addPluginsToJetBrainsProduct jetbrains.pycharm-professional [])
    (addPluginsToJetBrainsProduct jetbrains.clion [])
    (addPluginsToJetBrainsProduct jetbrains.webstorm [])
    (addPluginsToJetBrainsProduct jetbrains.goland [])
    (addPluginsToJetBrainsProduct jetbrains.idea-ultimate [])
    (addPluginsToJetBrainsProduct jetbrains.datagrip [])
    (addPluginsToJetBrainsProduct jetbrains.rust-rover [])
  ];

  x86JetbrainsProducts = with pkgs; [
    (addPluginsToJetBrainsProduct jetbrains.rider [])
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

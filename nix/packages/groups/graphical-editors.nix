{ pkgs, ... }:
let
  system = pkgs.system;

  # Common plugins for all JetBrains products
  commonPlugins = [
    "github-copilot"
    "nixidea"
  ];

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
    (addPluginsToJetBrainsProduct (jetbrains.rider.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
        expat
        libxml2
        xz
      ];
    }))[])
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
  else
    tools
      ++ jetbrainsProducts

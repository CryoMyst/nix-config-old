{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.terminal;

  tools = with pkgs; [ 
    git  
    htop
    btop
    unzip
    p7zip
    hdparm 
    wget  
    jq
    lazygit
    lazydocker
    zoxide 
    pciutils 
    valgrind
    distrobox
    screen
  ];
in {
  options.cryo.features.terminal = {
    enable = mkEnableOption "Enable terminal tools";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = tools;
        };
      };
    };
  };
}
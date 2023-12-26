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
    lazygit
    lazydocker
    zoxide 
    pciutils 
    valgrind
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
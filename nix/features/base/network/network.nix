{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.base.network;
in {
  options.cryo.features.base.network = {
    enable = mkEnableOption "Enable network configuration";
  };

  config = mkIf cfg.enable {
    networking = {
      firewall.enable = true;
      hostName = cryo.hostname;
      networkmanager.enable = true;
    };

    users.users = {
      ${cryo.username} = { 
        extraGroups = [ 
          "networkmanager" 
        ]; 
      };
    };
  };
}
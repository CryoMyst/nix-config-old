{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.services.network;
in {
  options.cryo.features.services.network = {
    enable = mkEnableOption "Enable network";
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
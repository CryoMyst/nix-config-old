{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.docker;
in {
  options.cryo.features.docker = {
    enable = mkEnableOption "Enable docker";
  };

  config = mkIf cfg.enable {
    users.users = {
      ${cryo.username} = { 
        extraGroups = [ "docker" ]; 
      };
    };

    virtualisation = {
      docker = {
        enable = true;
        logDriver = "json-file";
      };
    };
  };
}

{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.services.wayvnc;
in {
  options.cryo.features.services.wayvnc = {
    enable = mkEnableOption "Enable WayVNC";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            wayvnc
          ];
        };

        xdg.configFile.wayvnc = {
          source = ./wayvnc;
          recursive = true;
        };
      };
    };
  };
}
{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.swayidle;
in {
  options.cryo.features.swayidle = {
    enable = mkEnableOption "Enable swayidle";
  };

  config = mkIf cfg.enable {
    cryo.features.swaylock.enable = true;

    home-manager.users = {
      ${cryo.username} = { 
        home = { 
          packages = with pkgs; [ 
            swayidle 
          ]; 
        };

        services = {
          swayidle = {
            enable = true;
            timeouts = [{
              timeout = 300;
              command = "${pkgs.swaylock}/bin/swaylock -f";
            }];
          };
        };
      };
    };
  };
}
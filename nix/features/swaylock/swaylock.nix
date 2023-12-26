{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.swaylock;
in {
  options.cryo.features.swaylock = {
    enable = mkEnableOption "Enable swaylock";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = { 
          packages = with pkgs; [ 
            swaylock 
          ]; 
        };

        programs = {
          swaylock = {
            enable = true;
            settings = {
              color = "#000000";
              show-failed-attempts = true;
            };
          };
        };
      };
    };

    security = {
      pam = {
        services = {
          swaylock = {
            text = ''
              auth include login
            '';
          };
        };
      };
    };
  };
}
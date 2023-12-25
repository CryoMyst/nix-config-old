{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.desktop.alacritty;
in {
  options.cryo.features.desktop.alacritty = {
    enable = mkEnableOption "Alacritty";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = { 
          packages = with pkgs; [ 
            alacritty 
          ]; 
        };

        programs.alacritty = {
          enable = true;
          settings = {
            colors = {
              primary = {
                background = "0x000000";
              };
            };
          };
        };
      };
    };
  };
}
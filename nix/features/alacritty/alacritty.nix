{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.alacritty;
in {
  options.cryo.features.alacritty = {
    enable = mkEnableOption "Enable alacritty";
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
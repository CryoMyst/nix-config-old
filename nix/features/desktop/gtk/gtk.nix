{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.desktop.gtk;
in {
  options.cryo.features.desktop.gtk = {
    enable = mkEnableOption "Enable GTK configuration";
  };

  config = mkIf cfg.enable {
    environment = { 
      sessionVariables = { 
        GTK_THEME = "Adwaita:dark"; 
      }; 
    };

    home-manager.users = {
      ${cryo.username} = { 
        home = { 
          packages = with pkgs; [ 
            gnome.adwaita-icon-theme 
          ]; 
        };

        gtk = {
          enable = true;
          iconTheme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.adwaita-icon-theme;
          };
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.adwaita-icon-theme;
          };
        };
      };
    };
  };
}
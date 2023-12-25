{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.desktop.qt;
in {
  options.cryo.features.desktop.qt = {
    enable = mkEnableOption "Enable Qt integration";
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
            adwaita-qt
            adwaita-qt6
            qt5.qtwayland
            qt6.qtwayland
          ];
        };
        qt = {
          enable = true;
          platformTheme = "gnome";
          style.name = "adwaita-dark";
        };
      };
    };
  };
}
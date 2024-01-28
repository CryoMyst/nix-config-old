{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.themes.qt;
in {
  options.cryo.features.themes.qt = {
    enable = mkEnableOption "Enable QT themes.";
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
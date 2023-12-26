{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.qt;
in {
  options.cryo.features.qt = {
    enable = mkEnableOption "Enable QT";
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
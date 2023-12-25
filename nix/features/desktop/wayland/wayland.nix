{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.desktop.wayland;
in {
  options.cryo.features.desktop.wayland = {
    enable = mkEnableOption "Enable wayland tools";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            wl-clipboard
            waypipe
            waycheck
            grim
            slurp
          ];
        };
      };
    };
  };
}
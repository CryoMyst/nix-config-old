{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.wayland;
in {
  options.cryo.features.wayland = {
    enable = mkEnableOption "Enable wayland";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            wl-clipboard
            waypipe
            waycheck
            xwayland-run
            grim
            slurp
          ];
        };
      };
    };
  };
}
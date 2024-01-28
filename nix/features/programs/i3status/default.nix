{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.programs.i3status;
in {
  options.cryo.features.programs.i3status = {
    enable = mkEnableOption "Enable i3status";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        programs = {
          i3status = {
            enable = true;
            enableDefault = false;

            general = {
              colors = true;
              interval = 5;
            };

            modules = {
              "disk /" = {
                position = 1;
                settings = { format = "%avail"; };
              };

              "load" = {
                position = 2;
                settings = { format = "%1min"; };
              };

              "memory" = {
                position = 3;
                settings = {
                  format = "%used/%available";
                  threshold_degraded = "1G";
                  format_degraded = "MEMORY < %available";
                };
              };

              "tztime local" = {
                position = 100;
                settings = { format = "%Y-%m-%d %H:%M:%S"; };
              };
            };
          };
        };
      };
    };
  };
}
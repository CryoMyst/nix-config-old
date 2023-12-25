{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.desktop.xserver;
in {
  options.cryo.features.desktop.xserver = {
    enable = mkEnableOption "Enable X server";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        enableTCP = true;
        exportConfiguration = true;
        logFile = "/var/log/Xorg.0.log";
        # verbose = 7;
      };
    };
  };
}
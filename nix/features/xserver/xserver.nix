{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.xserver;
in {
  options.cryo.features.xserver = {
    enable = mkEnableOption "Enable X server";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            xorg.xhost
            xorg.xkill
          ];
        };
      };
    };
    services = {
      xserver = {
        enable = true;
        enableTCP = true;
        exportConfiguration = true;
        libinput.enable = true;
        logFile = "/var/log/Xorg.0.log";
        # verbose = 7;
      };
    };
  };
}
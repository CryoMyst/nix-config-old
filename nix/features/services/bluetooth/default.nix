{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.services.bluetooth;
in {
  options.cryo.features.services.bluetooth = {
    enable = mkEnableOption "Enable bluetooth support";
  };

  config = mkIf cfg.enable {
    services.blueman.enable = true;
    hardware = {
      enableAllFirmware = true;
      bluetooth = {
        enable = true; # enables support for Bluetooth
        powerOnBoot = true; # powers up the default Bluetooth controller on boot
        package = pkgs.bluez;
        settings = {
          General = {
            Name = cryo.hostname;
            ControllerMode = "dual";
            FastConnectable = "true";
            Experimental = "true";
          };
          Policy = {
            AutoEnable = "true";
          };
        };
      };
    };
  };
}
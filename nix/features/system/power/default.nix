{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.system.power;
in {
  options.cryo.system.power = {
    # Disables the power button on laptops and such
    disablePowerButton = mkEnableOption "Disable power button";
  };

  config = mkIf cfg.disablePowerButton {
    services.logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';
  };
}
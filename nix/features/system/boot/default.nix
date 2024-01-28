{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.system.boot;
in {
  options.cryo.features.system.boot = {
    enable = mkEnableOption "Enable boot";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          editor = false;
          configurationLimit = 10;
          consoleMode = pkgs.lib.mkDefault "auto";
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
      kernelPackages = pkgs.lib.mkDefault pkgs.linuxPackages_latest;
    };
  };
}
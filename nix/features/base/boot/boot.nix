{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.base.boot;
in {
  options.cryo.features.base.boot = {
    enable = mkEnableOption "Enable boot configuration";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          editor = true;
          configurationLimit = 20;
          consoleMode = pkgs.lib.mkDefault "auto";
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
      kernelPackages = pkgs.lib.mkDefault pkgs.linuxPackages_latest;
    };
  };
}
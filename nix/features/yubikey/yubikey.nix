{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.yubikey;
in {
  options.cryo.features.yubikey = {
    enable = mkEnableOption "Enable Yubikey";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.pcscd.enable = true;
  };
}
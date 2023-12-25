{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.base.base;

  permitted-insecure-packages = [
    "electron-25.9.0"
  ];
in {
  options.cryo.features.base.base = {
    enable = mkEnableOption "Enable base nixos configuration";
  };

  config = mkIf cfg.enable {
    nix = { 
      settings = { 
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      gc = {
        automatic = true;
        # interval = { Weekday = 0; Hour = 0; Minute = 0; };
        options = "--delete-older-than 7d";
      };
      optimise.automatic = true;
    };
    system.stateVersion = "unstable-01";
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;

      permittedInsecurePackages = permitted-insecure-packages;
    };
  };
}
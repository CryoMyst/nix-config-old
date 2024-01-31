{ lib, pkgs, config, home-manager, rust-overlay, nixpkgs, nixpkgs-stable, nixpkgs-unstable, nixpkgs-master, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.system.nix;

  permitted-insecure-packages = [
    "electron-25.9.0"
  ];
in {
  options.cryo.features.system.nix = {
    enable = mkEnableOption "Enable base nix system";
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
        sandbox = true;
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = [ "03:45" ];
      };
    };

    system.stateVersion = "unstable-01";
    
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = true;

        permittedInsecurePackages = permitted-insecure-packages;
      };
      overlays = [
        rust-overlay.overlays.default
      ] ++ (import ./../../../overlays/default.nix { inherit pkgs lib nixpkgs nixpkgs-stable nixpkgs-unstable nixpkgs-master; });
    };
  };
}

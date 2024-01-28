{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.system.home-manager;
in {
  imports = [
    home-manager.nixosModules.home-manager
    (import "${home-manager}/nixos")
  ];

  options.cryo.features.system.home-manager = {
    enable = mkEnableOption "Enable home-manager integration";
  };

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    home-manager.users = {
      ${cryo.username} = { 
        home = { 
          stateVersion = "23.05"; 
        }; 
      };
    };
  };
}
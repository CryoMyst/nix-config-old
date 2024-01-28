{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.setups.social;

  system = pkgs.system;
in {
  options.cryo.setups.social = {
    enable = mkEnableOption "Enable social";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = 
            (optionals (true) [
              pkgs.telegram-desktop
            ]) ++
            (optionals (system == "x86_64-linux") [
              pkgs.teamspeak_client
              pkgs.discord
            ]);
        };
      };
    };
  };
}
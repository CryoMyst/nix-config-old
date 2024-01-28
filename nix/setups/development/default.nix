{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.setups.development;
in {
  options.cryo.setups.development = {
    enable = mkEnableOption "Enable developer tools";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 

      };
    };
  };
}
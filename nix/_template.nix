{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.TODO;
in {
  options.cryo.TODO = {
    enable = mkEnableOption "TODO";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 

      };
    };
  };
}
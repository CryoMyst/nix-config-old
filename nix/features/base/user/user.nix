{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.base.user;
in {
  options.cryo.features.base.user = {
    enable = mkEnableOption "Enable user configuration";
  };

  config = mkIf cfg.enable {
    users.groups = { 
      "flakemanager" = { }; 
    };
    users.users = {
      ${cryo.username} = {
        isNormalUser = true;
        description = "${cryo.username}";
        extraGroups = [ "flakemanager" "wheel" ];
      };
    };
  };
}
{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.system.user;
in {
  options.cryo.features.system.user = {
    enable = mkEnableOption "Enable user";
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
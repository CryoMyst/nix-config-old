{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.services.strongswan;

  readJsonConfig = file: builtins.fromJSON (builtins.readFile file);
in {
  options.cryo.features.services.strongswan = {
    enable = mkEnableOption "Enable strongswan";
    external-json = mkOption {
      type = types.str;
      default = "";
      description = "Path to merge into the strongswan configuration";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enableStrongSwan = true;
    services.strongswan = 
    (
        if cfg.external-json != "" && builtins.pathExists cfg.external-json
        then readJsonConfig cfg.external-json 
        else {}
    ) // { enable = true; };

    home-manager.users = {
      ${cryo.username} = { 
        home = {
            packages = with pkgs; [
                strongswan
                openssl
                networkmanager
            ];
        };
      };
    };
  };
}
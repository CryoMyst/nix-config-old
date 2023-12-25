{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cfg = config.cryo;
in {
  imports = [
    ./features/features.nix
    ./setups/setups.nix
  ];

  options.cryo = {
    username = mkOption {
      type = types.str;
      description = ''
        The username to use for home-manager.
      '';
    };
    hostname = mkOption {
      type = types.str;
      description = "Hostname of the computer";
    };
  };
}
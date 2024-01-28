{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cfg = config.cryo;
in {
  imports = [
    ./features
    ./setups
    ./personal/personal.nix
  ];

  options.cryo = {
    username = mkOption {
      type = types.str;
      description = "The username to use.";
    };
    hostname = mkOption {
      type = types.str;
      description = "The hostname to use.";
    };
  };
}
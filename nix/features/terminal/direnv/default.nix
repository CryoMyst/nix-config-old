{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.terminal.direnv;
in {
  options.cryo.features.terminal.direnv = {
    enable = mkEnableOption "Enable direnv";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        programs = {
          direnv = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            nix-direnv = { 
              enable = true; 
            };
          };
        };
      };
    };
  };
}
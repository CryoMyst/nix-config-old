{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.social;

  system = pkgs.system;
  x86Social = with pkgs; [
    # x86 only social apps
    teamspeak_client
    discord
  ];

  social = with pkgs; [
    # Always included
    telegram-desktop
  ];

  social-packages = if system == "x86_64-linux" then
    social 
        ++ x86Social
  else
    social;
in {
  options.cryo.features.social = {
    enable = mkEnableOption "Enable social";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = social-packages;
        };
      };
    };
  };
}
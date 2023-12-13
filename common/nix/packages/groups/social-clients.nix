{ pkgs, ... }:
let
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

in
  if system == "x86_64-linux" then
    social 
        ++ x86Social
  else
    social

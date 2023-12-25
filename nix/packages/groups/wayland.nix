{ pkgs, ... }:
with pkgs; [
  xorg.xhost
  xorg.xkill
  brightnessctl
]

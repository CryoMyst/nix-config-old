{ pkgs, ... }:
with pkgs; [
  slurp
  grim
  wl-clipboard
  swaylock
  swayidle
  hyprpaper
  dunst
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xorg.xhost
  xorg.xkill
  qt5.qtwayland
  qt6.qtwayland
]
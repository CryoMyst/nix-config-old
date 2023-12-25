{ pkgs, ... }: {
  imports  = [
    ./alacritty/alacritty.nix
    ./gtk/gtk.nix
    ./i3status/i3status.nix
    ./qt/qt.nix
    ./sound/sound.nix
    ./sway/sway.nix
    ./swayidle/swayidle.nix
    ./swaylock/swaylock.nix
    ./wayland/wayland.nix
    ./wayvnc/wayvnc.nix
    ./xserver/xserver.nix
  ];
}

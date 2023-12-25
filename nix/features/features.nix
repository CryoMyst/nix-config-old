{ pkgs, home-manager, ... }: {
  imports  = [
    ./base/base.nix
    ./desktop/desktop.nix
    ./terminal/terminal.nix
    ./virtualisation/virtualisation.nix
  ];
}

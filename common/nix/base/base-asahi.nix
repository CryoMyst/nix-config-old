{ pkgs, nixos-apple-silicon, ... }: {
  imports = [
    ./base.nix
  ];

  nixpkgs.overlays = [
    nixos-apple-silicon.overlays.apple-silicon-overlay
    (import ../../../overlays/asahi.nix)
  ];
}

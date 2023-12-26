{ pkgs, home-manager, ... }: {
  imports = [
    ./shares/shares.nix
    ./ssh/ssh.nix
  ];
}
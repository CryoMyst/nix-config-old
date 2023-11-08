{ pkgs, ... }: {
  nix = { settings = { experimental-features = [ "nix-command" "flakes" ]; }; };
  system.stateVersion = "unstable-01";
  nixpkgs.config.allowUnfree = true;
}

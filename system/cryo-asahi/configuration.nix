{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
    ./../../common/nix/base/base.nix
    ./../../common/nix/base/extra-fonts.nix
    ./../../common/nix/base/graphics-asahi.nix
    ./../../common/nix/setups/sway-desktop.nix
  ];

  nixpkgs.overlays = [
    inputs.nixos-apple-silicon.overlays.apple-silicon-overlay
    inputs.nur.overlay
    (import ../../overlays/asahi.nix)
  ];

  boot = {
    kernelParams = [ "apple_dcp.show_notch=1" ];
  };

  services = {
    upower.enable = true;
    fstrim.enable = true;
    timesyncd.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}


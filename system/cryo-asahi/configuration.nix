{ pkgs, nixpkgs, nixos-apple-silicon, ... }: {

  imports = [
    nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
    ./../../common/nix/base/base.nix
    ./../../common/nix/base/extra-fonts.nix
    ./../../common/nix/base/graphics-asahi.nix
    ./../../common/nix/setups/sway-desktop.nix
  ];

  boot = { kernelParams = [ "apple_dcp.show_notch=1" ]; };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 64 * 1024;
  }];

  fileSystems = {
    "/mnt/ram" = {
      device = "nas.cryo.red:/ram";
      fsType = "nfs";
    };
    "/mnt/rem" = {
      device = "nas.cryo.red:/rem";
      fsType = "nfs";
    };
  };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
    };
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

    # List services that you want to enable:
  security.rtkit.enable = true;
  security.polkit.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}


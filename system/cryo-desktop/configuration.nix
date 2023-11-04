{
  imports = [
    ./hardware-configuration.nix
    ./../../common/nix/base/base.nix
    ./../../common/nix/base/extra-fonts.nix
    ./../../common/nix/base/graphics-amd.nix
    ./../../common/nix/setups/sway-desktop.nix
  ];

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
}

let
  gpu-ids = [
    "1002:73ff" # Graphics
    "1002:ab28" # Audio
  ];
in 
{ pkgs, lib, config, home-manager, user-config, ... }: {
  cryo.features.services.libvirt = {
    enable = true;
    host-cpu = "amd";
    pcie-devices = gpu-ids;
  };
  cryo.features.programs.looking-glass.enable = true;
}

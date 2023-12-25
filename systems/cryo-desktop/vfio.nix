let
  gpu-ids = [
    "1002:73ff" # Graphics
    "1002:ab28" # Audio
  ];
in 
{ pkgs, lib, config, home-manager, user-config, ... }: {
  cryo.features.virtualisation.libvirt = {
    enable = true;
    host-cpu = "amd";
    pcie-devices = gpu-ids;
    looking-glass = true;
  }; 
}

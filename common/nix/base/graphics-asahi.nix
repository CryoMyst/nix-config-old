{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
    ./../base/home-manager.nix
  ];

  hardware = {
    asahi = {
      addEdgeKernelConfig = true;
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "driver";
      withRust = true;
    };
    opengl.enable = true;
  };
}
{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  hardware = {
    asahi = {
      addEdgeKernelConfig = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "overlay";
      withRust = true;
      setupAlsaUcm = true;
    };
    opengl.enable = true;
  };
}

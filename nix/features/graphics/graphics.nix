{ lib, pkgs, config, home-manager, nixos-apple-silicon, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.graphics;
in {
  options.cryo.features.graphics = {
    enable = mkEnableOption "Enable graphics";
    gpu = mkOption {
      type = types.enum [ "amdgpu" "nvidia" "intel" "apple" ];
      default = null;
      description = "GPU to use";
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = if cfg.gpu == "amdgpu" then [ "amdgpu" ] else [];
    services.xserver.videoDrivers = if cfg.gpu == "amdgpu" then [ "amdgpu" ] else [];

    hardware = if cfg.gpu == "amdgpu" then {
      opengl = {
        enable = true;
        extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime amdvlk mesa.drivers ];
        extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
        driSupport = true;
        driSupport32Bit = true;
      };
    } else if cfg.gpu == "apple" then {
      asahi = {
        addEdgeKernelConfig = true;
        useExperimentalGPUDriver = true;
        experimentalGPUInstallMode = "overlay";
        withRust = true;
      };
      opengl.enable = true;
    } else {};
  };
}

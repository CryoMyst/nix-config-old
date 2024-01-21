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

  config = mkMerge [
    (mkIf cfg.enable {})
    (mkIf cfg.gpu == "amdgpu" {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware = {
        opengl = {
          enable = true;
          extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime amdvlk mesa.drivers ];
          extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
          driSupport = true;
          driSupport32Bit = true;
        };
      };
    })
    (mkIf cfg.gpu == "apple" {
      hardware = {
        asahi = {
          addEdgeKernelConfig = true;
          useExperimentalGPUDriver = true;
          experimentalGPUInstallMode = "overlay";
          withRust = true;
        };
        opengl.enable = true;
      };
    })
    (mkIf cfg.gpu == "nvidia" {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
          package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
      };
    })
  ];
}

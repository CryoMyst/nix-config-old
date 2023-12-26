{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.libvirt;
in {
  options.cryo.features.libvirt = {
    enable = mkEnableOption "Enable libvirt";
    host-cpu = mkOption {
      type = types.enum [ "intel" "amd" "apple" "none" ];
      default = "none";
      description = "The CPU type of the host";
    };
    pcie-devices = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of PCI devices to passthrough to the VM";
    };
    looking-glass = mkOption {
      type = types.bool;
      default = false;
      description = "Enable looking-glass";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = 
        let
          looking-glass-packages = if cfg.looking-glass then with pkgs; [ looking-glass-client ] else [];
        in
        {
          packages = with pkgs; [
            virt-manager 
          ] ++ looking-glass-packages;
        };
      };
    };

    # Not sure if this is needed
    hardware.opengl.enable = true;   

    boot = 
    let 
      pcie-devices-kernel-param = ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.pcie-devices);
    in
    {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];


      kernelParams = if cfg.host-cpu == "intel" then
        [ "intel_iommu=on" pcie-devices-kernel-param ]
      else if cfg.host-cpu == "amd" then
        [ "amd_iommu=on" pcie-devices-kernel-param ]
      else
        # Not sure if any flags are required for M1 or if PCIE 
        [];
    };

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
        };
      };
    };

    programs.dconf.enable = true;
    services.spice-vdagentd.enable = true;

    users.users = { 
      ${cryo.username} = { 
        extraGroups = [ 
          "libvirtd" 
        ]; 
      }; 
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${cryo.username} kvm -"
    ];
  };
}

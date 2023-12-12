let
  gpuIDs = [
    "1002:73ff" # Graphics
    "1002:ab28" # Audio
  ];
in 
{ pkgs, lib, config, home-manager, userConfig, ... }: {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        #"vfio_virqfd" # Now built into kernel

        #"nvidia"
        #"nvidia_modeset"
        #"nvidia_uvm"
        #"nvidia_drm"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
      ];
    };

    home-manager.users = {
      ${userConfig.username} = {
        home = { packages = with pkgs; [ looking-glass-client ]; };
      };
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${userConfig.username} kvm -"
    ];


    hardware.opengl.enable = true;
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
}

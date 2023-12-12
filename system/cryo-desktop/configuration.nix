{ pkgs, home-manager, userConfig, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../common/nix/base/base.nix
    ./../../common/nix/base/extra-fonts.nix
    ./../../common/nix/base/graphics-amd.nix
    ./../../common/nix/setups/sway-desktop.nix
    ./vfio.nix
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

  # Additional disks to mount
  fileSystems."/mnt/nvme2" = {
    device = "/dev/disk/by-uuid/d69b4e16-344f-4146-b55f-c4bc1518ea38";
    fsType = "ext4";
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
  };

  boot.kernelParams = [
    "zswap.enabled=1"
    "amd_pstate=active"
    "amd_iommu=on"
    "mitigations=off"
    "panic=1"
    "nowatchdog"
    "nmi_watchdog=0"
    "quiet"
    "rd.systemd.show_status=auto"
    "rd.udev.log_priority=3"
  ];

  services.blueman.enable = true;
  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      package = pkgs.bluez;
      settings = {
        General = {
          Name = "CryoDesktop";
          ControllerMode = "dual";
          FastConnectable = "true";
          Experimental = "true";
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  home-manager.users = {
    ${userConfig.username} = {
      wayland = {
        windowManager = {
          sway = {
            config = rec {
              keybindings = let
                # Just redefine here for now
                modifier = "Mod4";
              in pkgs.lib.mkOptionDefault {
                # 10th workspace for 2nd display
                "${modifier}+0" = "workspace number 10";
                "${modifier}+Shift+0" = "move container to workspace number 10";
              };

              output = {
                "HDMI-A-1" = {
                  mode = "3840x2160@120.000Hz";
                  pos = "1080,0";
                };
                "DP-1" = {
                  mode = "1920x1080@60.000Hz";
                  pos = "0,0";
                  transform = "270";
                };
              };

              workspaceOutputAssign = [
                {
                  output = "HDMI-A-1";
                  workspace = "1";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "2";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "3";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "4";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "5";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "6";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "7";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "8";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "9";
                }
                {
                  output = "DP-1";
                  workspace = "10";
                }
              ];
            };
          };
        };
      };
    };
  };
}

{ pkgs, nixpkgs, nixos-apple-silicon, user-config, ... }: 
let 
  speakersafetyd = (import ./speakers/speakersafetyd.nix) { inherit pkgs; };
in {

  imports = [
    nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
    ./speakers/enable-speakers.nix
    ./../../nix/modules.nix
  ];

  cryo = {
    username = "cryomyst";
    hostname = "cryo-asahi";
    setups.sway.enable = true;
    features.base.graphics.gpu = "asahi";
  };

  boot = { kernelParams = [ "apple_dcp.show_notch=0" ]; };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 64 * 1024;
  }];

  home-manager.users = {
    ${user-config.username} = {
      home = {
        packages = with pkgs; [
          speakersafetyd
          # citrix_workspace
        ];
      };

      wayland = {
        windowManager = {
          sway = {
            config = rec {
              keybindings = let
                modifier = "Mod4";
              in pkgs.lib.mkOptionDefault {
              };

              output = {
                "eDP-1" = {
                  mode = "3456x2160@60.000Hz";
                  scale = "1.2";
                };
              };
            };
          };
        };
      };

      xdg.desktopEntries = {
        "Firefox - CryoMyst" = {
          name = "Firefox CryoMyst";
          exec = "firefox -p CryoMyst";
          terminal = false;
        };
        "Firefox - Icon" = {
          name = "Firefox Icon";
          exec = "firefox -p Icon";
          terminal = false;
        };
      };

      programs = {
        i3status = {
          modules = {
            "battery 1" = {
              position = 4;
              settings = {
                path = "/sys/class/power_supply/macsmc-battery/uevent";
                format = "%percentage (%remaining)";
              };
            };
          };
        };
      };
    };
  };

  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  programs.nm-applet.enable = true;

  # fileSystems = {
  #   "/mnt/ram" = {
  #     device = "nas.cryo.red:/ram";
  #     fsType = "nfs";
  #   };
  #   "/mnt/rem" = {
  #     device = "nas.cryo.red:/rem";
  #     fsType = "nfs";
  #   };
  # };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;

    };
  };
  
  services.xserver.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.plasma6.enable = true;

  services = {
    upower.enable = true;
    fstrim.enable = true;
    timesyncd.enable = true;
    strongswan.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

    # List services that you want to enable:
  security.rtkit.enable = true;
  security.polkit.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.blueman.enable = true;
  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      package = pkgs.bluez;
      settings = {
        General = {
          Name = "Cryo-Asahi";
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
}


{ lib, pkgs, nixpkgs, nixos-apple-silicon, user-config, ... }: 
let 
in {

  imports = [
    nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
    ./../../nix/modules.nix
  ];

  cryo = {
    username = "cryomyst";
    hostname = "cryo-asahi";
    setups.sway.enable = true;
    features.graphics.gpu = "apple";
    features.sound.enable = lib.mkForce false;
    features.bluetooth.enable = true;
    features.strongswan = {
      enable = true;
      external-json = "/etc/nixos/secrets/vpns/work_vpns.json";
    };
    personal = {
      shares = {
        ram = true;
        rem = true;
      };
    };
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

  programs.nm-applet.enable = true;

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      setupAsahiSound = true;
    };
  };

  services = {
    upower.enable = true;
    fstrim.enable = true;
    timesyncd.enable = true;
  };

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
}


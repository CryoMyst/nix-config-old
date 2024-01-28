{ lib, pkgs, nixpkgs, nixos-apple-silicon, user-config, ... }: 
let 
  openlens-arm64 = (import ./../../nix/packages/custom/openlens-arm64.nix) { inherit pkgs; inherit lib; };
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
    features.system.graphics.gpu = "apple";
    # features.laptop.enable = true;
    features.services.sound.enable = lib.mkForce false;
    features.services.bluetooth.enable = true;
    features.terminal.nvim.setup = "cryo";
    features.services.libvirt.enable = false;
    features.services.strongswan = {
      enable = true;
      external-json = "/etc/nixos/secrets/vpns/work_vpns.json";
    };
    personal = {
      shares = {
        #ram = true;
        #rem = true;
      };
    };
  };

  boot = { 
    kernelParams = [ 
      "apple_dcp.show_notch=0"
      "hid_apple.fnmode=1"
    ]; 
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 64 * 1024;
  }];

  home-manager.users = {
    ${user-config.username} = {
      home = {
        packages = with pkgs; [
          azure-cli
          brightnessctl
        ] ++ [
          openlens-arm64
        ];
      };

      wayland = {
        windowManager = {
          sway = {
            config = rec {
              keybindings = let
                modifier = "Mod4";
              in pkgs.lib.mkOptionDefault {
                "${modifier}+Shift+i" = "exec swaymsg input type:touchpad events toggle";
                "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
                "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
                "Shift+XF86MonBrightnessUp" = "exec brightnessctl set +10% -d kbd_backlight";
                "Shift+XF86MonBrightnessDown" = "exec brightnessctl set 10%- -d kbd_backlight";

                # Screenshot
                "${modifier}+Shift+p" = ''exec grim -g "$(slurp)" - | wl-copy'';
              };

              output = {
                "HDMI-A-1" = {
                  mode = "3840x2160@60.000Hz";
                  pos = "0,0";
                };
                "eDP-1" = {
                  mode = "3456x2160@60.000Hz";
                  scale = "1.6";
                  pos = "3840,0";
                };
              };

              input = {
                "*" = {
                  natural_scroll = "disabled";
                  accel_profile = "flat";
                  pointer_accel = "0.5";
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


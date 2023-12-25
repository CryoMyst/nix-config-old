{ lib, pkgs, config, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.setups.sway;

  graphical-editors-pkgs =
    import ./../../packages/groups/graphical-editors.nix { inherit pkgs; };
  social-clients-pkgs =
    import ./../../packages/groups/social-clients.nix { inherit pkgs; };
  terminal-tools-pkgs =
    import ./../../packages/groups/terminal-tools.nix { inherit pkgs; };
  wayland-pkgs = import ./../../packages/groups/wayland.nix { inherit pkgs; };
  desktop-pkgs = import ./../../packages/groups/desktop.nix { inherit pkgs; };
  all-pkgs = graphical-editors-pkgs ++ social-clients-pkgs
    ++ terminal-tools-pkgs ++ wayland-pkgs ++ desktop-pkgs;
in {
  options.cryo.setups.sway = {
    enable = mkEnableOption "Enable cryo desktop sway setup";
  };

  config = mkIf cfg.enable {
    cryo = {
      features = {
        base = {
          base.enable = true;
          boot.enable = true;
          fonts.enable = true;
          home-manager.enable = true;
          network.enable = true;
          user.enable = true;
        };
        desktop = {
          sway.enable = mkDefault true;
        };
        terminal = {
          direnv.enable = mkDefault true;
          tmux.enable = mkDefault true;
          nvim.enable = mkDefault true;
          zsh.enable = mkDefault true;
        };
        virtualisation = {
          docker.enable = mkDefault true;
          libvirt.enable = mkDefault true;
        };
      };
    };

    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = all-pkgs;
        };
      };
    };

    security = { 
      pam = { 
        services = { 
          sddm.enableGnomeKeyring = true; 
        }; 
      }; 
    };

    programs = {
      dconf.enable = true;
      noisetorch.enable = true;
      zsh.enable = true;
      nix-ld.enable = true;
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
      };
    };

    services = {
      printing.enable = true;
      dbus.enable = true;
      openssh = {
        enable = true;
        settings = {
          X11Forwarding = true;
        };
      };
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      devmon.enable = true;
      tumbler.enable = true;

      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.sway}/bin/sway";
            user = "${cryo.username}";
          };
          default_session = initial_session;
        };
      };
    };
  };
}
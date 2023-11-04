{ pkgs, home-manager, userConfig, ... }:
# TODO: Move to a better location, eg terminal-tools-pkgs should be imported via the terminal.nix file
let
  graphical-editors-pkgs = import   ./../packages/groups/graphical-editors.nix { inherit pkgs; };
  social-clients-pkgs = import      ./../packages/groups/social-clients.nix { inherit pkgs; };
  terminal-tools-pkgs = import      ./../packages/groups/terminal-tools.nix { inherit pkgs; };
  wayland-pkgs = import             ./../packages/groups/wayland.nix { inherit pkgs; };
  desktop-pkgs = import             ./../packages/groups/desktop.nix { inherit pkgs; };
  all-pkgs = graphical-editors-pkgs 
    ++ social-clients-pkgs 
    ++ terminal-tools-pkgs 
    ++ wayland-pkgs
    ++ desktop-pkgs;
in
{
  imports = [
    ./terminal.nix
    ./../system/docker.nix
    ./../system/libvirtd.nix
    ./../desktop/sway.nix
  ];

  home-manager.users = {
    ${userConfig.username} = {
      home = {
        stateVersion = "23.05";
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
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  services = {
    printing.enable = true;
    dbus.enable = true;
    openssh.enable = true;
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
          user = "${userConfig.username}";
        };
        default_session = initial_session;
      };
    };
  };
}
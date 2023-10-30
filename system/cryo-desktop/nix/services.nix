{ config, pkgs, hyprland, userConfig, ... }:
{
  services = {
    printing.enable = true;
    dbus.enable = true;
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    tumbler.enable = true;
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    xserver = {
      enable = false;
      
      videoDrivers = [ "amdgpu" ];

      enableTCP = true;
      exportConfiguration = true;
      logFile = "/var/log/Xorg.0.log";
      verbose = 7;
    };

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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
    ];
  };
}

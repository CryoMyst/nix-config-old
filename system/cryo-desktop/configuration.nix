{ config, pkgs, hyprland, hy3, ... }:
{
  imports = [
    ./../../common/nix.nix
    ./../../common/fonts.nix
    ./home.nix
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = false;
  };

  networking = {
    hostName = "cryo-desktop";
    networkmanager.enable = true;
  };

  time.timeZone = "Australia/Brisbane";

  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
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

    xserver = {
      enable = true;
      
      videoDrivers = [ "amdgpu" ];

      enableTCP = true;
      exportConfiguration = true;
      logFile = "/var/log/Xorg.0.log";
      verbose = 7;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "cryomyst";
        };
        xserverArgs = [ "-listen tcp" ];
        # Don't select xterm session
        defaultSession = "hyprland";
        sessionData.autologinSession = "hyprland";
        sddm = {
          enable = true;
          settings = {
            X11.ServerArguments = "-listen tcp";
          };
        };
      };
      # desktopManager.plasma5.enable = true;

      layout = "au";
      xkbVariant = "";
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment = {
    sessionVariables = {
      # Breaks Hyprland
      # NIXOS_OZONE_WL = "1";
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
      # CROSS_CONTAINER_IN_CONTAINER = "true";

    };
    systemPackages = with pkgs; [
      nano
      git
      zip
      neofetch
      icu
      curl
    ];
  };

  sound.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services = {
        sddm.enableGnomeKeyring = true;
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };
  };

  users.users.cryomyst = {
    isNormalUser = true;
    description = "CryoMyst";
    shell = pkgs.zsh;
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "docker"
      "libvirtd"
    ];
    packages = with pkgs; [
      firefox
      kate
      kitty
      foot
      wofi
      obs-studio
      blender
      gimp
      freecad
      lutris
      wineWowPackages.staging
      winetricks
      noisetorch
      obsidian
      remmina
      freerdp
      parsec-bin
      virt-manager
      appimage-run
      gnome.file-roller
      moonlight-qt
      pavucontrol
      (let cura5 = appimageTools.wrapType2 rec {
        name = "cura5";
        version = "5.4.0";
        src = fetchurl {
          url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-modern.AppImage";
          hash = "sha256-QVv7Wkfo082PH6n6rpsB79st2xK2+Np9ivBg/PYZd74=";
        };
        extraPkgs = pkgs: with pkgs; [ ];
      }; in writeScriptBin "cura" ''
        #! ${pkgs.bash}/bin/bash
        # AppImage version of Cura loses current working directory and treats all paths relateive to $HOME.
        # So we convert each of the files passed as argument to an absolute path.
        # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.
        args=()
        for a in "$@"; do
          if [ -e "$a" ]; then
            a="$(realpath "$a")"
          fi
          args+=("$a")
        done
        exec "${cura5}/bin/cura5" "''${args[@]}"
      '')
    ];
  };

  programs = {
    steam.enable = true;
    dconf.enable = true;
    waybar.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    # (Required) NixOS Module: enables critical components needed to run Hyprland properly
    hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
      # xwayland = {
      #   enable = true;
      # };
    };
    zsh = { 
      enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
        async = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      enableLsColors = true;
      ohMyZsh = {
        enable = true;
        plugins = [ 
          "git"
        ];
        theme = "robbyrussell";
      };
      interactiveShellInit = ''
        export PATH="$HOME/.cargo/bin:$PATH"
      '';
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      logDriver = "json-file";
    };
    libvirtd = {
      enable = true;
    };
  };

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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
    ];
  };
}
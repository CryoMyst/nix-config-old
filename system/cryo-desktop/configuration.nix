{ config, pkgs, hyprland, ... }:

{
  imports = [
    ./home-manager.nix
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.05";

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
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
    
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      
      displayManager = {
        sddm = {
          enable = true;
          # settings = {
          #   Theme = {
          #     Current = "breeze";
          #     CursorTheme = "breeze_cursors";  
          #   };
          # };
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
    ];
    packages = with pkgs; [
      firefox
      kate
      gitkraken
      kitty
      foot
      teamspeak_client
      vscode
      discord
      telegram-desktop
      zsh
      slurp
      grim
      wl-clipboard
      htop
      wofi
      obs-studio
      swaylock
      waybar
      hyprpaper
      dunst
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      blender
      gimp
      freecad
      cura
      lutris
      wineWowPackages.staging
      winetricks
      jetbrains-toolbox
      dotnet-sdk_8
      noisetorch
      obsidian
      remmina
      freerdp
      parsec-bin
    ];
  };

  programs = {
    dconf.enable = true;
    hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        hidpi = true;
        enable = true;
      };
    };
    zsh = { 
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      logDriver = "json-file";
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

  fonts = {
    fonts = with pkgs; [
      corefonts
      ubuntu_font_family
      powerline-fonts
      font-awesome
      source-code-pro
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      emojione
      kanji-stroke-order-font
      ipafont
      liberation_ttf
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      jetbrains-mono
    ];
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
{ config, pkgs, hyprland, ... }:

{
  imports = [
    ./home-manager.nix
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 42;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  networking.hostName = "cryo-desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Brisbane";

  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
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

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
      lutris
      wineWowPackages.staging
      winetricks
      jetbrains-toolbox
      dotnet-sdk_8
    ];
  };

  environment.systemPackages = with pkgs; [
    nano
    git
    zip
    neofetch
  ];

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = "json-file";

  services.openssh.enable = true;
  programs.zsh = { 
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };


  fileSystems."/mnt/ram" = {
    device = "nas.cryo.red:/ram";
    fsType = "nfs";
  };

  fileSystems."/mnt/rem" = {
    device = "nas.cryo.red:/rem";
    fsType = "nfs";
  };

  programs.dconf.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  fonts.fonts = with pkgs; [
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

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.05";
}
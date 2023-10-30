{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix

    # Global settings
    ./../../common/nix/nix-settings.nix
    ./../../common/nix/additional-fonts.nix

    # Computer settings
    ./nix/environment.nix
    ./nix/hardware.nix
    ./nix/locale.nix
    ./nix/network.nix
    ./nix/programs.nix
    ./nix/security.nix
    ./nix/services.nix
    ./nix/sound.nix
    ./nix/user.nix

    # Home-manager settings
    ./home/home.nix
  ];
}

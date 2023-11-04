{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
    ./../base/home-manager.nix
  ];

  sound.enable = true;

  hardware = {
    pulseaudio.enable = false;
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
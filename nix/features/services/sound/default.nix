{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.services.sound;
in {
  options.cryo.features.services.sound = {
    enable = mkEnableOption "Enable sound";
  };

  config = mkIf cfg.enable {
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
  };
}
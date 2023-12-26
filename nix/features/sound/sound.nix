{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.sound;
in {
  options.cryo.features.sound = {
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
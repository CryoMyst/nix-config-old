{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.laptop;
in {
  options.cryo.features.laptop = {
    enable = mkEnableOption "Enable laptop features";
  };

  config = mkIf cfg.enable {
    services.logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';

    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            brightnessctl # Control screen brightness
          ];
        };
      };
    };
  };
}
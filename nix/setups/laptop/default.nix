{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.setups.laptop;
in {
  options.cryo.setups.laptop = {
    enable = mkEnableOption "Enable laptop setup";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        packages = with pkgs; [
          brightnessctl # Control screen brightness
        ];
      };
    };
  };
}
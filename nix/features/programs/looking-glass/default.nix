{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.programs.looking-glass;
in {
  options.cryo.features.programs.looking-glass = {
    enable = mkEnableOption "Enable looking-glass";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            looking-glass-client
          ];
        };
      };
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${cryo.username} kvm -"
    ];
  };
}
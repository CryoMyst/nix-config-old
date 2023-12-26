{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.tmux;
in {
  options.cryo.features.tmux = {
    enable = mkEnableOption "Enable tmux";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        programs = { 
          tmux = {
            enable = true;
            clock24 = true;
            disableConfirmationPrompt = false;
            extraConfig = ''
            
            '';
            keyMode = "vi";
            mouse = true;
            newSession = false;
            plugins = with pkgs.tmuxPlugins; [
              
            ];
            prefix = null;
            reverseSplit = false;
            secureSocket = false;
            sensibleOnTop = true;
            shell = null;
            shortcut = "b";
            terminal = "screen";
          };
        };
      };
    };
  };
}
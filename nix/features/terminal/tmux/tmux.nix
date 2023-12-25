{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.terminal.tmux;
in {
  options.cryo.features.terminal.tmux = {
    enable = mkEnableOption "tmux";
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
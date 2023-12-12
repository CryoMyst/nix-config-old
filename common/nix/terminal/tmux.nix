{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  home-manager.users = {
    ${userConfig.username} = { 
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
}

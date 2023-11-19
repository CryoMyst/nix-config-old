{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  home-manager.users = {
    ${userConfig.username} = { 
      xdg.configFile.nvim = {
        source = ./../../config/nvim;
        recursive = true;
      };

      programs = { 
        neovim = { 
          enable = true; 
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          # Overrides init.lua, source from $XDG_CONFIG_HOME/nvim/source.lua
          extraLuaConfig = ''
            require('source')
          '';
          plugins = with pkgs.vimPlugins; [
            telescope-nvim
            nvim-treesitter.withAllGrammars
          ];
        }; 
      };
    };
  };
}

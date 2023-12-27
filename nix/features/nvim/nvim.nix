{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.nvim;
in {
  options.cryo.features.nvim = {
    enable = mkEnableOption "Enable neovim";
  };

  config = mkIf cfg.enable {
    home-manager.users = {
      ${cryo.username} = { 
        xdg.configFile.nvim = {
          source = ./nvim;
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
              harpoon
              playground
              undotree
              vim-fugitive
              vim-nix
              direnv-vim

              # https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
              mason-nvim
              mason-lspconfig-nvim
              mason-tool-installer-nvim
              nvim-lspconfig
              cmp-nvim-lsp
              cmp-nvim-lsp-signature-help
              cmp-nvim-lsp-document-symbol

              rose-pine
            ];
          }; 
        };
      };
    };
  };
}

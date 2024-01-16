{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.nvim;
in {
  options.cryo.features.nvim = {
    enable = mkEnableOption "Enable neovim";
    setup = mkOption {
      type = types.enum [ "cryo" ];
      default = "cryo";
      description = ''
        A set of options to pass to the nvim module.
      '';
    };
  };

  # If enabled and setup is custom
  config = mkIf (cfg.enable && cfg.setup == "cryo") {
    home-manager.users = {
      ${cryo.username} = { 
        xdg.configFile.nvim = {
          source = ./nvim;
          recursive = true;
        };

        home = {
          packages = with pkgs; [
            ripgrep
          ];
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
              vim.g.nix = { 
                omnisharp_roslyn = { path = "${pkgs.omnisharp-roslyn}/bin/OmniSharp"; };
                rust_analyzer = { path = "${pkgs.rust-analyzer}/bin/rust-analyzer"; };
                clippy = { path = "${pkgs.clippy}/bin/clippy-driver"; };
                netcoredbg = { path = "${pkgs.netcoredbg}/bin/netcoredbg"; };
              };
              require('source')
            '';
            
            plugins = with pkgs.vimPlugins; [
              telescope-nvim
              nvim-treesitter.withAllGrammars
              harpoon
              playground
              undotree
              vim-fugitive
              direnv-vim

              # https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
              lsp-zero-nvim
              nvim-lspconfig
              nvim-cmp
              cmp-nvim-lsp
              cmp-nvim-lsp-signature-help
              cmp-nvim-lsp-document-symbol
              luasnip

              # https://aaronbos.dev/posts/debugging-csharp-neovim-nvim-dap
              nvim-dap
              nvim-dap-ui

              rose-pine
              dracula-nvim

              vim-be-good
            ];

            extraPackages = with pkgs; [
              omnisharp-roslyn
              rust-analyzer
              clippy
              netcoredbg
            ];
          }; 
        };
      };
    };
  };
}

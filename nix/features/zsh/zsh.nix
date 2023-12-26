{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.zsh;
in {
  options.cryo.features.zsh = {
    enable = mkEnableOption "Enable zsh";
  };

  config = mkIf cfg.enable {
    programs = { 
      zsh.enable = true; 
    };

    environment.shells = with pkgs; [ zsh ];

    users.users = { 
      ${cryo.username} = { 
        shell = pkgs.zsh; 
      }; 
    };

    home-manager.users = {
      ${cryo.username} = { 
        programs = {
          zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            enableVteIntegration = true;
            history = { ignoreAllDups = true; };
            oh-my-zsh = {
              enable = true;
              plugins = [ 
                "git" 
                "sudo" 
                "docker"
                "docker-compose"
                "dotnet"
                "gitignore"
                "man"
                "rust"
                "terraform"
                "zoxide"
              ];
              theme = "robbyrussell";
            };
            syntaxHighlighting = { enable = true; };

            shellAliases = {
              # nohup without nohup.out file
              "qnohup" = "f() { nohup $1 &> /dev/null &disown };f";
            };

            plugins = [
              {
                name = "zsh-nix-shell";
                file = "nix-shell.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "chisui";
                  repo = "zsh-nix-shell";
                  rev = "v0.7.0";
                  sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
                };
              }
            ];
          };
        };
      };
    };
  };
}

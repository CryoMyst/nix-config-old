{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
    ./../base/home-manager.nix
  ];

  programs = {
    zsh.enable = true;
  };
  environment.shells = with pkgs; [ 
    zsh 
  ];
  
  users.users = {
    ${userConfig.username} = {
      shell = pkgs.zsh;
    };
  };

  home-manager.users = {
    ${userConfig.username} = {
      programs = {
        zsh = {
          enable = true;
          enableAutosuggestions = true;
          enableCompletion = true;
          enableVteIntegration = true;
          history = {
            ignoreAllDups = true;
          };
          oh-my-zsh = {
            enable = true;
            plugins = [
              "git"
              "sudo"
            ];
            theme = "robbyrussell";
          };
          syntaxHighlighting = {
            enable = true;
          };

          shellAliases = {
            # nohup without nohup.out file
            "qnohup" = "f() { nohup $1 &> /dev/null &disown };f";
          }; 
        };
      };
    };
  };
}
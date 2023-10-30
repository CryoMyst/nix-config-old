{ config, pkgs, home-manager, userConfig, ... }:
{
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
        };
      };
    };
  };
}
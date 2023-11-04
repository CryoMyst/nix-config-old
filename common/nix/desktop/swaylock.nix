{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
    ./../base/home-manager.nix
  ];

  security = {
    pam = {
      services = {
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };
  };

  home-manager.users = {
    ${userConfig.username} = {
      home = {
        packages = with pkgs; [
          swaylock
        ];
      };

      programs = {
        swaylock = {
          enable = true;
          settings = {
            color = "#000000";
            show-failed-attempts = true;
          };
        };
      };
    };
  };
}
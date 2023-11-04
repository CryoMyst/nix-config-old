{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
    ./../base/home-manager.nix
    ./swaylock.nix
  ];

  home-manager.users = {
    ${userConfig.username} = {
      home = {
        packages = with pkgs; [
          swayidle
        ];
      };

      services = {
        swayidle = {
          enable = true;
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.swaylock}/bin/swaylock -f";
            }
          ];
        };
      };
    };
  };
}
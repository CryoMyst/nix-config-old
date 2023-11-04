{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
  ];

  users.users = {
    ${userConfig.username} = {
      extraGroups = [
        "docker"
      ];
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      logDriver = "json-file";
    };
  };
}
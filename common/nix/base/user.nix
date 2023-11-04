{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./base.nix
    ./locale.nix
  ];

  users.groups = {
    "flakemanager" = {};
  };
  users.users = {
    ${userConfig.username} = {
      isNormalUser = true;
      description = "${userConfig.user-description}";
      extraGroups = [
        "flakemanager"
        "wheel"
      ];
    };
  };
}
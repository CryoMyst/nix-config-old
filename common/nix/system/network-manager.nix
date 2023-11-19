{ pkgs, home-manager, userConfig, computerConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  networking.firewall.enable = true;
  networking = {
    hostName = computerConfig.hostname;
    networkmanager.enable = true;
  };

  users.users = {
    ${userConfig.username} = { extraGroups = [ "networkmanager" ]; };
  };
}

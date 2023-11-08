{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ];

  virtualisation = { libvirtd = { enable = true; }; };

  users.users = { ${userConfig.username} = { extraGroups = [ "libvirtd" ]; }; };
}

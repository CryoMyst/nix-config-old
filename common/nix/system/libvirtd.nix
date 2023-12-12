{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ];

  virtualisation = { libvirtd = { enable = true; }; };
  programs.dconf.enable = true;
  services.spice-vdagentd.enable = true;
  users.users = { ${userConfig.username} = { extraGroups = [ "libvirtd" ]; }; };
}

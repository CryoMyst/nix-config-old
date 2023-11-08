{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  home-manager.users = {
    ${userConfig.username} = {
      programs = {
        i3status = {
          enable = true;
          enableDefault = true;
        };
      };
    };
  };
}

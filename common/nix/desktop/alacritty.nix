{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  home-manager.users = {
    ${userConfig.username} = {
      home = { packages = with pkgs; [ alacritty ]; };

      programs.alacritty = {
        enable = true;
        settings = {
          colors = {
            primary = {
              background = "0x000000";
            };
          };
        };
      };
    };
  };
}

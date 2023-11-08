{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  environment = { sessionVariables = { GTK_THEME = "Adwaita:dark"; }; };

  home-manager.users = {
    ${userConfig.username} = {
      home = { packages = with pkgs; [ gnome.adwaita-icon-theme ]; };

      gtk = {
        enable = true;
        iconTheme = {
          name = "Adwaita-dark";
          package = pkgs.gnome.adwaita-icon-theme;
        };
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome.adwaita-icon-theme;
        };
      };
    };
  };
}

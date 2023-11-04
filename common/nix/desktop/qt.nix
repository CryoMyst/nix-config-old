{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/user.nix
    ./../base/home-manager.nix
  ];

  environment = {
    sessionVariables = { 
      GTK_THEME = "Adwaita:dark"; 
    };
  };

  home-manager.users = {
    ${userConfig.username} = {
      home = {
        packages = with pkgs; [
          adwaita-qt
          adwaita-qt6
          qt5.qtwayland
          qt6.qtwayland
        ];
      };
      qt = {
        enable = true;
        platformTheme = "gnome";
        style.name = "adwaita-dark";
      };
    };
  };
}
{ config, pkgs, home-manager, ... }:

{
  imports = [
    (import "${home-manager}/nixos")
  ];

  environment.sessionVariables = { 
    GTK_THEME = "Adwaita:dark"; 
  };

  home-manager.backupFileExtension = "backup";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      cryomyst = {
        
        home = {
          stateVersion = "23.05";
          packages = [
          ];
        };

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

        qt = {
          enable = true;
          platformTheme = "gnome";
          style.name = "adwaita-dark";
        };
      };
    };
  };
}

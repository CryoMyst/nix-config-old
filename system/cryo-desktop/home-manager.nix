{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/refs/heads/release-23.05.zip";
    sha256 = "1lhkqlizabh107mgj9b3fsfzz6cwpcmplkwspqqavwqr9dlmlwc4";
  };
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  environment.sessionVariables = { 
    GTK_THEME = "Adwaita:dark"; 
  };

  home-manager.backupFileExtension = "backup";
  home-manager = {
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
      };
    };
  };
}

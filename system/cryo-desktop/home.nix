{ config, pkgs, home-manager, hyprland, ... }:

let
  development-pkgs = import ./packages/development.nix { inherit pkgs; };
  social-pkgs = import ./packages/social.nix { inherit pkgs; };
  terminal-pkgs = import ./packages/terminal.nix { inherit pkgs; };
  wayland-pkgs = import ./packages/wayland.nix { inherit pkgs; };

  all-pkgs = development-pkgs ++ social-pkgs ++ terminal-pkgs ++ wayland-pkgs;
in
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
          packages = all-pkgs;
        };

        wayland = {
          windowManager = {
            hyprland = {
              enable = true;
              package = hyprland.packages.${pkgs.system}.hyprland;
              extraConfig = ''
                ${builtins.readFile ./dotfiles/hypr/hyprland.conf}
              '';
              xwayland = {
                enable = true;
              };
            };
          };
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

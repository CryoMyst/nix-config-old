{ config, pkgs, hyprland, home-manager, userConfig, ... }:

let
  graphical-editors-pkgs = import   ./../../../common/packages/groups/graphical-editors.nix { inherit pkgs; };
  social-clients-pkgs = import      ./../../../common/packages/groups/social-clients.nix { inherit pkgs; };
  terminal-tools-pkgs = import      ./../../../common/packages/groups/terminal-tools.nix { inherit pkgs; };
  wayland-pkgs = import             ./../../../common/packages/groups/wayland.nix { inherit pkgs; };
  desktop-pkgs = import             ./../../../common/packages/groups/desktop.nix { inherit pkgs; };
  all-pkgs = graphical-editors-pkgs 
    ++ social-clients-pkgs 
    ++ terminal-tools-pkgs 
    ++ wayland-pkgs
    ++ desktop-pkgs;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users = {
    ${userConfig.username} = {
      home = {
        stateVersion = "23.05";
        packages = all-pkgs;
      };

      wayland = {
        windowManager = {
          # exec_always xrandr --output $(xrandr | grep -m 1 3840x2160 | awk '{print $1;}') --primary
          sway = {
            enable = true;

            config = rec {
              modifier = "Mod4";
              terminal = "kitty"; 
              startup = [

              ];
              defaultWorkspace = "1";
              floating = {
                titlebar = true;
              };
              focus = {
                mouseWarping = false;
              };

              keybindings = let
                # Just redefine here for now
                modifier = "Mod4";
              in pkgs.lib.mkOptionDefault {
                "${modifier}+Shift+Escape" = "exec pkill -SIGUSR1 swayidle";
                "${modifier}+d" = "exec wofi --show drun";
                "${modifier}+Shift+d" = "exec wofi --show run";
                # "${modifier}+n" = "exec pkill -SIGUSR1 '^waybar$'"; # Kills it currently
                
                # Screenshot
                "${modifier}+Print" = "exec \"grim -g \"$(slurp)\" - | wl-copy\"";
                # Edit the system flake
                "${modifier}+f1" = "exec ${pkgs.vscode}/bin/code /etc/nixos/flake/";

                # 10th workspace for 2nd display
                "${modifier}+0" = "workspace number 10";
                "${modifier}+Shift+0" = "move container to workspace number 10";
              };

              modes = {
                resize = {
                  Escape = "mode default";
                  Return = "mode default";
                  h = "resize shrink width 10 px";
                  j = "resize grow height 10 px";
                  k = "resize shrink height 10 px";
                  l = "resize grow width 10 px";
                };
              };

              output = {
                "*" = {
                  bg = "#000000 solid_color";
                };
                "HDMI-A-1" = {
                  mode = "3840x2160@120.000Hz";
                  pos = "1080,0";
                };
                "DP-1" = {
                  mode = "1920x1080@60.000Hz";
                  pos = "0,0";
                  transform = "270";
                };
              };

              workspaceOutputAssign = [
                { output = "HDMI-A-1"; workspace = "1"; }
                { output = "HDMI-A-1"; workspace = "2"; }
                { output = "HDMI-A-1"; workspace = "3"; }
                { output = "HDMI-A-1"; workspace = "4"; }
                { output = "HDMI-A-1"; workspace = "5"; }
                { output = "HDMI-A-1"; workspace = "6"; }
                { output = "HDMI-A-1"; workspace = "7"; }
                { output = "HDMI-A-1"; workspace = "8"; }
                { output = "HDMI-A-1"; workspace = "9"; }
                { output = "DP-1"; workspace = "10"; }
              ];
            };
          };
        };
      };

      programs = {
        swaylock = {
          enable = true;
          settings = {
            color = "#000000";
            show-failed-attempts = true;
          };
        };

        neovim = {
          enable = true;
        };
      };

      services = {
        swayidle = {
          enable = true;
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.swaylock}/bin/swaylock -f";
            }
          ];
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

      programs = {
        zsh = {
          enable = true;
          enableAutosuggestions = true;
          enableCompletion = true;
          enableVteIntegration = true;
          history = {
            ignoreAllDups = true;
          };
          oh-my-zsh = {
            enable = true;
            plugins = [
              "git"
              "sudo"
            ];
            theme = "robbyrussell";
          };
          syntaxHighlighting = {
            enable = true;
          };
        };

        direnv = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;

          nix-direnv = {
            enable = true;
          };
        };
      };
    };
  };
}

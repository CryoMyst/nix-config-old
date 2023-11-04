{ pkgs, home-manager, userConfig, ... }:
{
  imports = [
    ./../base/boot.nix
    ./../base/user.nix
    ./../base/home-manager.nix
    ./../system/network-manager.nix
    ./qt.nix
    ./gtk.nix
    ./sound.nix
    ./swayidle.nix
    ./swaylock.nix
    ./i3status.nix
    ./xserver.nix
  ];

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
    ];
  };

  home-manager.users = {
    ${userConfig.username} = {
      wayland = {
        windowManager = {
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

              bars = [
                {
                  fonts = {
                    names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
                    size = 11.0;
                  };
                  mode = "dock";
                  hiddenState = "hide";
                  position = "bottom";
                  statusCommand = "${pkgs.i3status}/bin/i3status";
                  command = "${pkgs.sway}/bin/swaybar";
                  workspaceButtons = true;
                  workspaceNumbers = false;
                  trayOutput = "primary";
                  colors = {
                    "background" = "#000000";
                    "statusline" = "#ffffff";
                    "separator" = "#666666";
                    "focusedWorkspace" = {
                      border = "#4c7899";
                      background = "#285577";
                      text = "#ffffff";
                    };
                    "activeWorkspace" = {
                      border = "#333333";
                      background = "#5f676a";
                      text = "#ffffff";
                    };
                    "inactiveWorkspace" = {
                      border = "#333333";
                      background = "#222222";
                      text = "#888888";
                    };
                    "urgentWorkspace" = {
                      border = "#2f343a";
                      background = "#900000";
                      text = "#ffffff";
                    };
                    "bindingMode" = {
                      border = "#2f343a";
                      background = "#900000";
                      text = "#ffffff";
                    };
                  };
                }
              ];

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

              # TODO: Move to specific to computer
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
    };
  };
}
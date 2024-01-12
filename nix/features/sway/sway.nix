{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.sway;
in {
  options.cryo.features.sway = {
    enable = mkEnableOption "Enable sway";
    modifier = mkOption {
      type = types.str;
      default = "Mod4";
      description = "Modifier key for Sway";
    };
  };

  config = mkIf cfg.enable {
    cryo.features = {
      nix.enable = true;
      user.enable = true;
      fonts.enable = true;
      home-manager.enable = true;
      graphics.enable = true;
      locale.enable = true;
      swaylock.enable = true;
      swayidle.enable = true;
      xserver.enable = true;
      qt.enable = true;
      gtk.enable = true;
      i3status.enable = true;
      alacritty.enable = true;
      sound.enable = true;
      wayvnc.enable = true;
      wayland.enable = true;
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    home-manager.users = {
      ${cryo.username} = { 
        home = {
          packages = with pkgs; [
            alacritty
            sway
            swayidle
            swaylock
            waybar
            i3status
            hyprpaper
            
            grim
            wl-clipboard
            slurp

            wofi
            dmenu
            dunst
            
            # xdg-desktop-portal-gtk
            vscode
          ];
        };

        wayland = {
          windowManager = {
            sway = {
              enable = true;
              extraConfig = ''
                for_window {
                  [shell="xwayland"] title_format "%title [XWayland]"
                  [app_id="firefox"] inhibit_idle fullscreen
                  [app_id="mpv"] inhibit_idle fullscreen
                  [window_role="pop-up"] floating enable
                  [window_role="bubble"] floating enable
                  [window_role="dialog"] floating enable
                  [window_type="dialog"] floating enable
                }
              '';

              config = rec {
                modifier = "${cfg.modifier}";
                terminal = "alacritty";
                startup = [
                  
                ];



                defaultWorkspace = "1";
                floating = { titlebar = true; };
                focus = { mouseWarping = false; };

                keybindings = let
                  # Just redefine here for now
                  modifier = "${cfg.modifier}";
                in pkgs.lib.mkOptionDefault {
                  "${modifier}+Control+Shift+l" = "move workspace to output right";
                  "${modifier}+Control+Shift+h" = "move workspace to output left";
                  "${modifier}+Control+Shift+j" = "move workspace to output down";
                  "${modifier}+Control+Shift+k" = "move workspace to output up";
                  "${modifier}+Control+Shift+Right" = "move workspace to output right";
                  "${modifier}+Control+Shift+Left" = "move workspace to output left";
                  "${modifier}+Control+Shift+Down" = "move workspace to output down";
                  "${modifier}+Control+Shift+Up" = "move workspace to output up";

                  "${modifier}+t" = "exec ${terminal}";
                  "${modifier}+Shift+Escape" = "exec pkill -SIGUSR1 swayidle";
                  "${modifier}+d" = "exec wofi --show drun";
                  "${modifier}+Shift+d" = "exec wofi --show run";
                  # "${modifier}+n" = "exec pkill -SIGUSR1 '^waybar$'"; # Kills it currently

                  # Screenshot
                  "${modifier}+Print" = ''exec grim -g "$(slurp)" - | wl-copy'';
                  # Edit the system flake
                  "${modifier}+f1" =
                    "exec ${pkgs.vscode}/bin/code /etc/nixos/flake/";
                };

                bars = [{
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
                }];

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

                output = { "*" = { bg = "#000000 solid_color"; }; };
              };
            };
          };
        };
      };
    };
  };
}

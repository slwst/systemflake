{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.windowManager.i3;
in {
  options.modules.windowManager.i3 = {
    enable = mkEnableOption "Adds i3 binds, supporting features, and rice";
  };

  config = mkIf cfg.enable ({
      services.polybar.enable=true;
      services.picom.enable=true;
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        config = rec {
          modifier = "Mod4";
          terminal = "kitty";
          defaultWorkspace = "workspace number 0";
          assigns = {
            "0:term" = [{class = "^kitty-primary$";}];
            "1:web" = [{window_role = "^browser$";}];
            "2:comms" = [{class = "^discord$";} {class = "^Session$";}];
            "3:mail" = [{class = "^thunderbird$";}];
            "7:gaming" = [{class = "^Steam$";}];
            "8:music" = [{class = "^Spotify$";} {class = "^GLava$";}];
            "9:sysmon" = [{class = "^kitty-btm$";}];
          };

          workspaceOutputAssign = [
            {
              workspace = "0:term";
              output = "primary";
            }
            {
              workspace = "1:web";
              output = "nonprimary";
            }
            {
              workspace = "2:comms";
              output = "nonprimary";
            }
            {
              workspace = "3:mail";
              output = "primary";
            }
            {
              workspace = "7:gaming";
              output = "primary";
            }
            {
              workspace = "8:music";
              output = "nonprimary";
            }
            {
              workspace = "9:sysmon";
              output = "nonprimary";
            }
          ];
          bars = [];
          fonts = {
            names = ["mononoki Nerd Font"];
            size = 14.0;
          };

          gaps = {
            inner = 5;
            outer = 5;
          };

          window.border = 0;

          floating = {
            criteria = [
              {
                title = "Steam - Update News";
              }
              {
                class = "Pavucontrol";
              }
              {
                title = "NVIDIA Settings";
              }
              {
                class = ".blueman-manager-wrapped";
              }
              {
                class = "Gucharmap";
              }
            ];
            modifier = "${modifier}";
          };

          startup = [
            {command = "touchegg";}
            {command = "kitty --class=kitty-primary";}
            {command = "firefox";}
            {command = "thunderbird";}
            {command = "kitty --class=kitty-btm btm";}
            {
              command =
                (pkgs.writeShellScriptBin "music-startup" ''
                  i3-msg 'exec spotify'
                  ${pkgs.coreutils}/bin/sleep 1
                  i3-msg 'workspace 8:music; split vertical'
#                  i3-msg 'exec glava'
#                  ${pkgs.coreutils}/bin/sleep 1
#                  i3-msg '[class="^GLava$"] resize set height 20 ppt'
                '')
                + "/bin/music-startup";
            }
          ];

          keybindings = lib.mkOptionDefault {
            # Movement
            # alphas
            "${modifier}+j" = "exec i3-msg border pixel 1; focus left";
            "${modifier}+k" = "exec i3-msg border pixel 1; focus down";
            "${modifier}+l" = "exec i3-msg border pixel 1; focus up";
            "${modifier}+apostrophe" = "exec i3-msg border pixel 1; focus right";
            "--release ${modifier}+j" = "exec i3-msg border pixel 0";
            "--release ${modifier}+k" = "exec i3-msg border pixel 0";
            "--release ${modifier}+l" = "exec i3-msg border pixel 0";
            "--release ${modifier}+apostrophe" = "exec i3-msg border pixel 0";

            # cursor keys
            "${modifier}+Left" = "exec i3-msg border pixel 1; focus left";
            "${modifier}+Down" = "exec i3-msg border pixel 1; focus down";
            "${modifier}+Up" = "exec i3-msg border pixel 1; focus up";
            "${modifier}+Right" = "exec i3-msg border pixel 1; focus right";
            "--release ${modifier}+Left" = "exec i3-msg border pixel 0";
            "--release ${modifier}+Down" = "exec i3-msg border pixel 0";
            "--release ${modifier}+Up" = "exec i3-msg border pixel 0";
            "--release ${modifier}+Right" = "exec i3-msg border pixel 0";

            # Media Keys
            # Volume
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            # Player Controls
            "XF86AudioPlay" = "exec playerctl -a play-pause";
            "XF86AudioPause" = "exec playerctl -a play-pause";
            "XF86AudioNext" = "exec playerctl -a next";
            "XF86AudioPrev" = "exec playerctl -a previous";
            # Brightness
            "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";

            # Programs
            "${modifier}+Return" = "exec kitty";
            "${modifier}+Shift+c" = "exec rofi -modi calc -show calc";
            "${modifier}+d" = "exec rofi -modi drun -show drun";
            "${modifier}+m" = "exec rofi -modi emoji -show emoji";
            "${modifier}+Shift+d" = "exec rofi -show window";
            "${modifier}+b" = "exec firefox";
            "${modifier}+Shift+x" = "exec systemctl suspend";
            "${modifier}+Shift+p" = "exec rofi -modi power-menu:rofi-power-menu -show power-menu";
            "${modifier}+Shift+s" = "exec rofi-pulse-select sink";

            # Workspaces
            "${modifier}+0" = "workspace 0:term";
            "${modifier}+1" = "workspace 1:web";
            "${modifier}+2" = "workspace 2:comms";
            "${modifier}+3" = "workspace 3:mail";
            "${modifier}+7" = "workspace 7:gaming";
            "${modifier}+8" = "workspace 8:music";
            "${modifier}+9" = "workspace 9:sysmon";

            # Screenshots
            "Print" = "exec --no-startup-id maim ${config.xdg.userDirs.pictures}/screenshot-$(date +%Y%m%d-%H%M%S).png";
            "${modifier}+Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) ${config.xdg.userDirs.pictures}/screenshot-$(date +%Y%m%d-%H%M%S).png";
            "Shift+Print" = "exec --no-startup-id maim --select ${config.xdg.userDirs.pictures}/screenshot-$(date +%Y%m%d-%H%M%S).png";
            # Screenshots (Clipboard)
            "Ctrl+Print" = "exec --no-startup-id maim | xclip -selection clipboard -t image/png";
            "Ctrl+${modifier}+Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) | xclip -selection clipboard -t image/png";
            "Ctrl+Shift+Print" = "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";

            # Blink window with focus
            "${modifier}+z" = "exec i3-msg border pixel 1";
            "--release ${modifier}+z" = "exec i3-msg border pixel 0";
          };

          modes = {
            resize = {
              j = "resize shrink width 10 px or 10 ppt";
              k = "resize grow height 10 px or 10 ppt";
              l = "resize shrink height 10 px or 10 ppt";
              apostrophe = "resize grow width 10 px or 10 ppt";
              Left = "resize shrink width 10 px or 10 ppt";
              Up = "resize grow height 10 px or 10 ppt";
              Down = "resize shrink height 10 px or 10 ppt";
              Right = "resize grow width 10 px or 10 ppt";
              Return = "mode default";
              Escape = "mode default";
            };
          };
        };
      };
      home = {
        packages = with pkgs; [
          maim
          xclip
          xdotool
        ];
      };
    }
    // import ./picom.nix);
}

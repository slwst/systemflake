{
  pkgs,
  lib,
  config,
  home,
  ...
}:
with lib; let
  cfg = config.modules.windowManager.sway;
in {
  options.modules.windowManager.sway = {
    enable = mkEnableOption "Adds sway binds, supporting features, and rice";
  };

  config = mkIf cfg.enable ({ 
    modules.desktop.services.waybar.enable = true;
    modules.desktop.services.swaylock.enable = true;
    home.packages = with pkgs; mkMerge [
      # Basic
      [ swaybg autotiling glib ]
      # Used in Keybindings
      [ grim slurp wl-clipboard libnotify light ]
    ];
    home.sessionVariables = {
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    };
    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
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
            output = "DP-1";
          }
          {
            workspace = "1:web";
            output = "HDMI-A-1";
          }
          {
            workspace = "2:comms";
            output = "HDMI-A-1";
          }
          {
            workspace = "3:mail";
            output = "DP-1";
          }
          {
            workspace = "7:gaming";
            output = "DP-1";
          }
          {
            workspace = "8:music";
            output = "HDMI-A-1";
          }
          {
            workspace = "9:sysmon";
            output = "HDMI-A-1";
          }
        ];
        bars = [{ command = "waybar"; }];
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
                i3-msg 'exec spotifywm'
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
          "Ctrl+Shift+Print" = "exec --no-startup-id grim -g \"$(slurp)\" - | wl-copy";

          # Blink window with focus
          "${modifier}+z" = "exec i3-msg border pixel 1";
          "--release ${modifier}+z" = "exec i3-msg border pixel 0";
        };
      };
    };
  programs.wofi.enable = true;
  services.kanshi = {
    enable = true;
    profiles.default.outputs = [
      {
        criteria = "ASUSTek COMPUTER INC PG39WCDM S5LMTF202563";
        mode = "3440x1440@240Hz";
        position = "0,0";
        adaptiveSync = true;
      }
      /*
      {
        criteria = "Ancor Communications Inc ROG PG348Q #ASPjnRq62OXd";
        mode = "3440x1440@100Hz";
        position = "0,0";
        adaptiveSync = true;
      }
      */
      {
        criteria = "LG Electronics 27EA83R 0x01010101";
        mode = "2560x1440@60Hz";
        position = "3440,0";
      }
    ];
  };
  });
  }
 

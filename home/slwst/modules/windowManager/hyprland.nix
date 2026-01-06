{
  pkgs,
  lib,
  config,
  home,
  ...
}:
with lib; let
  cfg = config.modules.windowManager.hyprland;
in {
  options.modules.windowManager.hyprland = {
    enable = mkEnableOption "Adds hyprland binds, supporting features, and rice";
  };

  config = mkIf cfg.enable ({
    modules.desktop.services.waybar-hypr.enable = true;
    catppuccin = {
      hyprland = {
        enable = true;
        flavor = "macchiato";
        accent = "teal";
      };
      fuzzel = {
        enable = true;
        flavor = "macchiato";
        accent = "teal";
      };
    };
    programs.fuzzel.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      # electron wayland hint
      #home.sessionVariables.NIXOS_OZONE_WL = "1";

      # installed via nixos module
      package = null;
      portalPackage = null;

      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$menu" = "wofi --show drun";

        monitor = [
          "DP-1, 3440x1440@240, 0x0, 1"
          "HDMI-A-1, 2560x1440@60, 3440x0, 1"
        ];
        xwayland = {
          force_zero_scaling = true;
        };

        exec-once = ["waybar"];

        general = {
          gaps_in = 6;
          gaps_out = 6;
          border_size = 2;
          layout = "dwindle";
          allow_tearing = true;
          "col.active_border" = "0xff00ffff";
        };

        input = {
          kb_layout = "us";
          follow_mouse = true;
          touchpad = {
            natural_scroll = true;
          };
          accel_profile = "flat";
          sensitivity = 0;
        };

        decoration = {
          rounding = 15;
          active_opacity = 0.9;
          inactive_opacity = 0.8;
          fullscreen_opacity = 1;

          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 14;
            passes = 4;
            brightness = 1;
            noise = 0.01;
            contrast = 1;
            popups = true;
            popups_ignorealpha = 0.6;
            ignore_opacity = false;
          };

          #drop_shadow = true;
          #shadow_ignore_window = true;
          #shadow_range = 20;
          #shadow_offset = "0 2";
          #shadow_render_power = 4;
        };

        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        cursor = {
          enable_hyprcursor = true;
        };

        dwindle = {
          pseudotile = true;
          permanent_direction_override = true;
          preserve_split = true;
          #no_gaps_when_only = 0;
          smart_split = false;
          smart_resizing = false;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vrr = 3;
        };         
        bind = [
          # General
          "$mod, return, exec, $terminal"
          "$mod SHIFT, q, killactive"
          "$mod SHIFT, e, exit"
          "$mod SHIFT, l, exec, ${pkgs.hyprlock}/bin/hyprlock"

          # Screen focus
          "$mod, v, togglefloating"
          "$mod, u, focusurgentorlast"
          "$mod, tab, focuscurrentorlast"
          "$mod, f, fullscreen"

          # Screen resize
          "$mod CTRL, j, resizeactive, -20 0"
          "$mod CTRL, apostrophe, resizeactive, 20 0"
          "$mod CTRL, l, resizeactive, 0 -20"
          "$mod CTRL, k, resizeactive, 0 20"

          # Workspaces
          "$mod, t, workspace, name:"
          "$mod, b, workspace, name:"
          "$mod CTRL, s, workspace, name:"
          "$mod CTRL, f, workspace, name:󰈹"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move to workspaces
          "$mod SHIFT, t, movetoworkspace, name:"
          "$mod SHIFT, b, movetoworkspace, name:"
          "$mod SHIFT_ALT, f, movetoworkspace, name:󰈹"
          "$mod SHIFT_ALT, s, movetoworkspace, name:"
          "$mod SHIFT, 1, movetoworkspace,1"
          "$mod SHIFT, 2, movetoworkspace,2"
          "$mod SHIFT, 3, movetoworkspace,3"
          "$mod SHIFT, 4, movetoworkspace,4"
          "$mod SHIFT, 5, movetoworkspace,5"
          "$mod SHIFT, 6, movetoworkspace,6"
          "$mod SHIFT, 7, movetoworkspace,7"
          "$mod SHIFT, 8, movetoworkspace,8"
          "$mod SHIFT, 9, movetoworkspace,9"
          "$mod SHIFT, 0, movetoworkspace,10"

          # Window Movement
          "$mod SHIFT, j, movewindow, l"
          "$mod SHIFT, apostrophe, movewindow, r"
          "$mod SHIFT, l, movewindow, u"
          "$mod SHIFT, k, movewindow, d"

          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"

          # Navigation
          "$mod, j, movefocus, l"
          "$mod, apostrophe, movefocus, r"
          "$mod, l, movefocus, u"
          "$mod, k, movefocus, d"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Applications
          "$mod ALT, e, exec, $terminal --hold -e ${pkgs.yazi}/bin/yazi"
          #"$mod ALT, f, exec, ${pkgs.firefox}/bin/firefox"
          "$mod ALT, f, exec, firefox"
          "$mod ALT, v, exec, pkill pavucontrol || pavucontrol"
          "$mod, d, exec, pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel"
          #"$mod ALT, r, exec, pkill anyrun || ${pkgs.anyrun}/bin/anyrun"
          #"$mod ALT, n, exec, swaync-client -t -sw"

          # Clipboard
          "$mod CTRL_ALT, v, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"

          # Screencapture
          "$mod, s, exec, ${pkgs.grim}/bin/grim | wl-copy"
          "$mod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g \"$(slurp)\" - | wl-copy"

          # Mumble
          "$mod SHIFT, C, exec, ${pkgs.glib}/bin/gdbus call -e -d net.sourceforge.mumble.mumble -o / -m net.sourceforge.mumble.Mumble.startTalking"
        ];
        bindr = [
          # Mumble
          "$mod SHIFT, C, exec, ${pkgs.glib}/bin/gdbus call -e -d net.sourceforge.mumble.mumble -o / -m net.sourceforge.mumble.Mumble.stopTalking"
        ];
        bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
        ];

        #audio
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
        ];
        windowrule = [
          "match:class org.pulseaudio.pavucontrol, float on"
          "match:class xdg-desktop-portal-gtk, float on"
          "match:class org.pulseaudio.pavucontrol, size 1024 1024"
          "match:class steam, opaque on"
          "match:class firefox no_blur on"
          "match:class firefox opacity 1.0"
          "match:title EVE, tile on"
          "match:title EVE, no_blur on"
          "match:title EVE, opacity 1.0"
          "match:title (.*)(EVE)(.*)$, opaque on"
          "match:title (.*)(Firefox)$, opaque on"
          "match:title (.*)(Spotify)(.*)$, opaque on"
        ];
        /*
        windowrule = [
          "float, class:org.pulseaudio.pavucontrol"
          "float, class:xdg-desktop-portal-gtk"
          "size 1024 576, class:org.pulseaudio.pavucontrol"
          "no_blur on, class:steam"
          "opacity 1.0, class:steam"
          "no_blur on, class:firefox"
          "opacity 1.0, class:firefox"
          "tile, title:EVE"
          "opaque, title:(.*)(EVE)(.*)$"
          "opaque, title:(.*)(Firefox)$"
          "opaque, title:(.*)(Spotify)(.*)$"
        ];
        */

        layerrule = [
          "match:namespace waybar, blur on"
        ];
        workspace = [
          #"name:󰈹, on-created-empty:${pkgs.firefox}/bin/firefox, monitor:HDMI-A-1, default:true"
          "name:󰈹, on-created-empty:firefox, monitor:HDMI-A-1, default:true"
          "name:, on-created-empty:kitty, monitor:DP-1, default:true"
          "name:, on-created-empty:kitty --session sysmon.session, monitor:HDMI-A-1, default:true"
          "name:, on-created-empty:steam, monitor:DP-1"
        ];
      };
    };
    programs.eww = {
      enable = false;
      enableFishIntegration = true;
    };
    programs.wofi.enable = true;
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "/home/slwst/pics/wallpaper/catppuccin/buttons.png"
          "/home/slwst/pics/wallpaper/catppuccin/catppuccin_triangle.png"
          "/home/slwst/pics/wallpaper/catppuccin/dark-cat.png"
        ];
        wallpaper = [
          "DP-1,/home/slwst/pics/wallpaper/catppuccin/catppuccin_triangle.png"
          "HDMI-A-1,/home/slwst/pics/wallpaper/catppuccin/buttons.png"
        ];
      };
    };
    services.kanshi = {
      enable = true;
      settings = [
        { profile.name = "default";
          profile.outputs = [
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
        }
      ];
    };
  });
}

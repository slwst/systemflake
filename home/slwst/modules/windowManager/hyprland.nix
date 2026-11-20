{
  pkgs,
  lib,
  config,
  home,
  ...
}:
with lib; let
  cfg = config.modules.windowManager.hyprland;

  # --- lua config plumbing ---------------------------------------------------
  # Hyprland 0.57 dropped hyprlang entirely: hyprland.conf is no longer read at
  # all (it logs "No config file found" and writes a default hyprland.lua over
  # the top), so this module targets the lua config via configType = "lua".
  #
  # home-manager renders each `settings` attribute as an `hl.<name>(...)` call.
  # Two escape hatches carry the things a plain attrset cannot express:
  #   { _args = [ a b ]; }  ->  hl.name(a, b)   -- a multi-argument call
  #   mkLuaInline "expr"    ->  expr, verbatim  -- e.g. a dispatcher object
  # `curve` is in home-manager's importantPrefixes, so beziers are emitted
  # before the animations that name them.
  inherit (lib.generators) mkLuaInline;
  luaStr = lib.generators.toLua {};

  mod = "SUPER";
  terminal = "kitty";

  # hl.bind(keys, dispatcher) / hl.bind(keys, dispatcher, opts)
  bind = keys: dispatcher: {_args = [keys (mkLuaInline dispatcher)];};
  bindWith = opts: keys: dispatcher: {_args = [keys (mkLuaInline dispatcher) opts];};
  exec = keys: cmd: bind keys "hl.dsp.exec_cmd(${luaStr cmd})";
  execWith = opts: keys: cmd: bindWith opts keys "hl.dsp.exec_cmd(${luaStr cmd})";

  # bindel -> fires while held; bindl -> still fires while the session is locked
  held = {
    locked = true;
    repeating = true;
  };
  whenLocked = {locked = true;};

  # Nerd-font workspace names, byte-identical to the previous hyprlang config.
  wsTerm = "";
  wsSysmon = "";
  wsSteam = "";
  wsWeb = "󰈹";

  # The vim-ish home row (j/apostrophe/l/k) and the arrows drive the same moves.
  # rx/ry are the resizeactive deltas that used to ride on $mod CTRL.
  dirs = [
    {
      key = "j";
      arrow = "left";
      dir = "left";
      rx = -20;
      ry = 0;
    }
    {
      key = "apostrophe";
      arrow = "right";
      dir = "right";
      rx = 20;
      ry = 0;
    }
    {
      key = "l";
      arrow = "up";
      dir = "up";
      rx = 0;
      ry = -20;
    }
    {
      key = "k";
      arrow = "down";
      dir = "down";
      rx = 0;
      ry = 20;
    }
  ];

  named = [
    {
      name = wsTerm;
      focus = "T";
      move = "SHIFT + T";
    }
    {
      name = wsSysmon;
      focus = "B";
      move = "SHIFT + B";
    }
    {
      name = wsSteam;
      focus = "CTRL + S";
      move = "SHIFT + ALT + S";
    }
    {
      name = wsWeb;
      focus = "CTRL + F";
      move = "SHIFT + ALT + F";
    }
  ];

  # --- display layout --------------------------------------------------------
  # These three attrsets are the single source of truth for the layout: both
  # the `monitor` setting and the VR toggle below are generated from them, so
  # the toggle cannot drift out of sync with what is declared.
  #
  # Connector names as of the current hardware (hyprctl monitors all):
  #   DP-1      ASUSTek PG39WCDM   primary, 3440x1440@240
  #   DP-3      LG ULTRAGEAR       right of primary, 2560x1440@200
  #   HDMI-A-2  LG 27EA83R         left of primary, portrait, 2560x1440@60
  #   HDMI-A-1  HTC-VIVE           headset - deliberately has NO rule
  #
  # Portrait is transform 3 (270deg), so it occupies 1440x2560 and sits at
  # negative x. The landscape pair is pushed to y=560 to centre all three.
  monPrimary = {
    output = "DP-1";
    mode = "3440x1440@240";
    position = "0x560";
    scale = 1;
  };
  monRight = {
    output = "DP-3";
    mode = "2560x1440@200";
    position = "3440x560";
    scale = 1;
  };
  monPortrait = {
    output = "HDMI-A-2";
    mode = "2560x1440@60";
    position = "-1440x0";
    scale = 1;
    # 3 = 270deg. transform = 1 (90deg) came out upside down on this panel, so
    # the rotation it needs is the other direction.
    transform = 3;
  };

  # hl.monitor({ ... }) for a monitor attrset. toLua renders it as a Lua table
  # literal, so a rule is spelled out exactly once, in Nix.
  monitorCall = m: "hl.monitor(${luaStr m})";

  # --- VR display profile ----------------------------------------------------
  # The Vive's direct-mode output needs a 297.0 MHz pixel clock and this GPU
  # cannot deliver that on top of the whole desktop. Measured on epsilon
  # 2026-11-08, in both directions:
  #
  #   DP-1@240 1385 + DP-3@200 816 + portrait@60 241.5 + headset 297
  #     = ~2739 MHz -> SteamVR dies during headset setup (error -203)
  #   the same minus the portrait panel
  #     = ~2498 MHz -> works, and holds for a long session
  #
  # This is a bandwidth ceiling, not a compositor bug: the same two totals fail
  # and succeed under KWin as well, which is what made the earlier "KWin bug"
  # reading of -203 wrong. The exact threshold is somewhere between those two
  # figures and has not been pinned down. nvidia-modeset logs a related
  # complaint ("RLD advertized maximum pixel clock 290000/320000 KHz violates
  # maximum pixel clock constraint for HDMI") but that link is unconfirmed.
  #
  # So VR mode keeps both high-refresh panels and sheds only the portrait one,
  # which is exactly the habit this replaces.
  #
  # Re-enabling is deliberately TWO rules, and the first is not redundant.
  # applyMonitorRule records m_activeMonitorRule only on the branch that
  # handles an already-disabled output and in applyMonitorRuleSoft; handing the
  # full geometry rule to an output that is currently off takes neither path,
  # so it early-returns without recording the rule and
  # MonitorRuleManager::ensureMonitorStatus never switches the output back on.
  # A minimal { output, disabled = false } does go through the soft path, which
  # records it, and only then does the geometry rule land. Verified against
  # 0.57.0: the full rule alone leaves the output at enabled=false, while
  # minimal-then-full brings it back at transform 3 in the right position.
  vrToggleLua = ''
    local target = ${luaStr monPortrait.output}
    local mon
    for _, m in ipairs(hl.get_monitors({ all = true })) do
      if m.name == target then
        mon = m
      end
    end
    if not mon then
      hl.notification.create({
        text = "vr-mode: " .. target .. " is not connected",
        timeout = 4000,
        icon = 2,
      })
      return
    end
    if mon.enabled then
      hl.monitor({ output = target, disabled = true })
      hl.notification.create({
        text = "VR mode ON - portrait off, DP-1@240 + DP-3@200",
        timeout = 4000,
        icon = 1,
      })
    else
      hl.monitor({ output = target, disabled = false })
      ${monitorCall monPortrait}
      hl.notification.create({
        text = "VR mode OFF - all three monitors",
        timeout = 4000,
        icon = 1,
      })
    end'';

  # The same toggle, reachable from a shell or a launcher as well as the bind.
  # `hyprctl eval` runs the identical Lua inside the compositor, so there is
  # only ever one implementation of the dance. hyprctl is deliberately NOT
  # referenced by store path: `package = null` below means Hyprland comes from
  # the NixOS module, and this has to drive that instance.
  vrToggleScript = pkgs.writeShellScriptBin "vr-display-toggle" ''
    exec hyprctl eval ${escapeShellArg vrToggleLua}
  '';

  displayBinds = [
    (bind "${mod} + SHIFT + V" ''
      function()
      ${vrToggleLua}
      end'')
  ];

  generalBinds = [
    (exec "${mod} + Return" terminal)
    (bind "${mod} + SHIFT + Q" "hl.dsp.window.close()")
    (bind "${mod} + SHIFT + E" "hl.dsp.exit()")
    # NOTE: SUPER+SHIFT+L collides with "move window up" further down, which is
    # registered later and therefore wins. The same collision existed in the
    # hyprlang config, so this is carried over rather than silently repaired.
    (exec "${mod} + SHIFT + L" "${pkgs.hyprlock}/bin/hyprlock")

    (bind "${mod} + V" "hl.dsp.window.float({ action = \"toggle\" })")
    (bind "${mod} + U" "hl.dsp.focus({ window = \"urgent_or_last\" })")
    (bind "${mod} + Tab" "hl.dsp.focus({ window = \"current_or_last\" })")
    (bind "${mod} + F" "hl.dsp.window.fullscreen()")
  ];

  resizeBinds =
    map (
      d: bind "${mod} + CTRL + ${d.key}" "hl.dsp.window.resize({ x = ${toString d.rx}, y = ${toString d.ry} })"
    )
    dirs;

  namedWorkspaceBinds =
    concatMap (w: [
      (bind "${mod} + ${w.focus}" "hl.dsp.focus({ workspace = ${luaStr "name:${w.name}"} })")
      (bind "${mod} + ${w.move}" "hl.dsp.window.move({ workspace = ${luaStr "name:${w.name}"} })")
    ])
    named;

  numWorkspaceBinds =
    concatMap (
      n: let
        key =
          if n == 10
          then "0"
          else toString n;
      in [
        (bind "${mod} + ${key}" "hl.dsp.focus({ workspace = ${toString n} })")
        (bind "${mod} + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${toString n} })")
      ]
    )
    (range 1 10);

  moveBinds =
    concatMap (d: [
      (bind "${mod} + SHIFT + ${d.key}" "hl.dsp.window.move({ direction = ${luaStr d.dir} })")
      (bind "${mod} + SHIFT + ${d.arrow}" "hl.dsp.window.move({ direction = ${luaStr d.dir} })")
    ])
    dirs;

  focusBinds =
    concatMap (d: [
      (bind "${mod} + ${d.key}" "hl.dsp.focus({ direction = ${luaStr d.dir} })")
      (bind "${mod} + ${d.arrow}" "hl.dsp.focus({ direction = ${luaStr d.dir} })")
    ])
    dirs;

  appBinds = [
    (exec "${mod} + ALT + E" "${terminal} --hold -e ${pkgs.yazi}/bin/yazi")
    (exec "${mod} + ALT + F" "firefox")
    (exec "${mod} + ALT + V" "pkill pavucontrol || pavucontrol")
    (exec "${mod} + D" "pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel")
    (exec "${mod} + CTRL + ALT + V" "pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy")
    (exec "${mod} + S" "${pkgs.grim}/bin/grim | wl-copy")
    (exec "${mod} + SHIFT + S" "${pkgs.grim}/bin/grim -g \"$(slurp)\" - | wl-copy")
  ];

  # Push-to-talk: press opens the mic, release closes it. hyprlang kept these in
  # separate bind/bindr tables; lua folds both into hl.bind with opts, so the
  # pair shares one key and wants a functional check.
  mumbleBinds = let
    gdbus = method: "${pkgs.glib}/bin/gdbus call -e -d net.sourceforge.mumble.mumble -o / -m net.sourceforge.mumble.Mumble.${method}";
  in [
    (exec "${mod} + SHIFT + C" (gdbus "startTalking"))
    (execWith {release = true;} "${mod} + SHIFT + C" (gdbus "stopTalking"))
  ];

  mouseBinds = [
    (bindWith {mouse = true;} "${mod} + mouse:272" "hl.dsp.window.drag()")
    (bindWith {mouse = true;} "${mod} + mouse:273" "hl.dsp.window.resize()")
  ];

  mediaBinds = [
    (execWith held "XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
    (execWith held "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
    (execWith whenLocked "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    (execWith whenLocked "XF86AudioPlay" "playerctl play-pause")
    (execWith whenLocked "XF86AudioPrev" "playerctl previous")
    (execWith whenLocked "XF86AudioNext" "playerctl next")
  ];

  curveOf = name: points: {_args = [name {inherit points; type = "bezier";}];};

  # The on_created_empty workspace rule is deprecated in 0.57; upstream's
  # replacement is a "workspace.created" handler that tests the workspace's
  # is_empty field. The handler is passed exactly one argument, an HL.Workspace
  # userdata (probed against 0.57.0: argc=1, with .name / .is_empty / .monitor
  # populated and .id nil for a named workspace).
  spawnOnEmpty = {
    "${wsWeb}" = "firefox";
    "${wsTerm}" = terminal;
    "${wsSysmon}" = "${terminal} --session sysmon.session";
    "${wsSteam}" = "steam";
  };
  # Kept as a plain function expression rather than an immediately-invoked
  # closure: mkLuaInline already wraps its argument in parentheses, so an IIFE
  # would need a trailing ")(" here to balance, which is unreadable. Rebuilding
  # a four-entry table per workspace creation costs nothing.
  spawnOnEmptyHandler = mkLuaInline ''
    function(ws)
      if not ws.is_empty then
        return
      end
      local spawn = {
    ${concatStringsSep "\n" (mapAttrsToList (
      ws: cmd: "        [${luaStr ws}] = ${luaStr cmd},"
    ) spawnOnEmpty)}
      }
      local cmd = spawn[ws.name]
      if cmd then
        hl.exec_cmd(cmd)
      end
    end'';
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

    # SUPER+SHIFT+V is the same toggle; this is for scripts and launchers.
    home.packages = [vrToggleScript];

    # Hyprland writes a default hyprland.lua at compositor startup whenever the
    # file is missing, and that file is a real file, not a symlink -- so
    # home-manager's checkLinkTargets refuses to clobber it and activation
    # fails with "Existing file ... would be clobbered". Any login that happens
    # while the symlink is absent (a first switch onto lua, a generation
    # rollback) re-arms that trap, so claim the path unconditionally.
    xdg.configFile."hypr/hyprland.lua".force = true;

    wayland.windowManager.hyprland = {
      enable = true;
      # electron wayland hint
      #home.sessionVariables.NIXOS_OZONE_WL = "1";

      # installed via nixos module
      package = null;
      portalPackage = null;

      # Required, not merely preferred: 0.57 reads hyprland.lua and nothing
      # else. The catppuccin module also targets lua (it contributes
      # `local colors = require('themes.catppuccin')`).
      configType = "lua";

      settings = {
        curve = [
          (curveOf "linear" [[0 0] [1 1]])
          (curveOf "md3_standard" [[0.2 0] [0 1]])
          (curveOf "md3_decel" [[0.05 0.7] [0.1 1]])
          (curveOf "md3_accel" [[0.3 0] [0.8 0.15]])
          (curveOf "overshot" [[0.05 0.9] [0.1 1.1]])
          (curveOf "crazyshot" [[0.1 1.5] [0.76 0.92]])
          (curveOf "hyprnostretch" [[0.05 0.9] [0.1 1.0]])
          (curveOf "menu_decel" [[0.1 1] [0 1]])
          (curveOf "menu_accel" [[0.38 0.04] [1 0.07]])
          (curveOf "easeInOutCirc" [[0.85 0] [0.15 1]])
          (curveOf "easeOutCirc" [[0 0.55] [0.45 1]])
          (curveOf "easeOutExpo" [[0.16 1] [0.3 1]])
          (curveOf "softAcDecel" [[0.26 0.26] [0.15 1]])
          (curveOf "md2" [[0.4 0] [0.2 1]])
        ];

        # Do NOT add a rule for HDMI-A-1, and in particular never disabled =
        # true. aquamarine already flags the headset as a non-desktop connector,
        # and Monitor.cpp::onConnect handles that case by skipping desktop
        # configuration and offering the connector over wp_drm_lease_device_v1,
        # which is how SteamVR acquires direct mode. The disabled branch sits
        # ABOVE that one and returns early, so a disabled rule suppresses the
        # lease offer: SteamVR then binds the lease device, receives an empty
        # connector list and dies with VRInitError_Compositor_CannotDRMLeaseDisplay
        # (error 496). applyMonitorRule also early-returns on non-desktop
        # outputs ("don't touch VR headsets"), so no rule is needed to protect it.
        #
        # The layout itself lives in monPrimary / monRight / monPortrait in the
        # let block, which the VR toggle shares.
        monitor = [monPrimary monRight monPortrait];

        config = {
          general = {
            gaps_in = 6;
            gaps_out = 6;
            border_size = 2;
            layout = "dwindle";
            allow_tearing = true;
            col.active_border = "0xff00ffff";
          };

          input = {
            kb_layout = "us";
            follow_mouse = true;
            accel_profile = "flat";
            sensitivity = 0;
            touchpad.natural_scroll = true;
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
          };

          animations.enabled = true;

          cursor.enable_hyprcursor = true;

          dwindle = {
            # dwindle.pseudotile was removed as a config key in 0.57; the
            # hl.dsp.window.pseudo() dispatcher is the remaining way in.
            permanent_direction_override = true;
            preserve_split = true;
            smart_split = false;
            smart_resizing = false;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 3;
          };

          xwayland.force_zero_scaling = true;
        };

        animation = [
          {leaf = "windows"; enabled = true; speed = 3; bezier = "md3_decel"; style = "popin 60%";}
          {leaf = "windowsIn"; enabled = true; speed = 3; bezier = "md3_decel"; style = "popin 60%";}
          {leaf = "windowsOut"; enabled = true; speed = 3; bezier = "md3_accel"; style = "popin 60%";}
          {leaf = "border"; enabled = true; speed = 10; bezier = "default";}
          {leaf = "fade"; enabled = true; speed = 3; bezier = "md3_decel";}
          {leaf = "layersIn"; enabled = true; speed = 3; bezier = "menu_decel"; style = "slide";}
          {leaf = "layersOut"; enabled = true; speed = 1.6; bezier = "menu_accel";}
          {leaf = "fadeLayersIn"; enabled = true; speed = 2; bezier = "menu_decel";}
          {leaf = "fadeLayersOut"; enabled = true; speed = 4.5; bezier = "menu_accel";}
          {leaf = "workspaces"; enabled = true; speed = 7; bezier = "menu_decel"; style = "slide";}
          {leaf = "specialWorkspace"; enabled = true; speed = 3; bezier = "md3_decel"; style = "slidevert";}
        ];

        bind =
          generalBinds
          ++ resizeBinds
          ++ namedWorkspaceBinds
          ++ numWorkspaceBinds
          ++ moveBinds
          ++ focusBinds
          ++ appBinds
          ++ mumbleBinds
          ++ mouseBinds
          ++ mediaBinds
          ++ displayBinds;

        # Rules that shared a match in the hyprlang config are folded into one
        # call each; same effect, one rule per window class/title.
        window_rule = [
          {
            name = "pavucontrol";
            match.class = "org.pulseaudio.pavucontrol";
            float = true;
            size = "1024 1024";
          }
          {
            name = "portal-gtk";
            match.class = "xdg-desktop-portal-gtk";
            float = true;
          }
          {
            name = "steam";
            match.class = "steam";
            opaque = true;
          }
          {
            name = "firefox";
            match.class = "firefox";
            no_blur = true;
            opacity = 1.0;
          }
          {
            name = "eve";
            match.title = "EVE";
            tile = true;
            no_blur = true;
            opacity = 1.0;
          }
          {
            name = "eve-opaque";
            match.title = "(.*)(EVE)(.*)$";
            opaque = true;
          }
          {
            name = "firefox-opaque";
            match.title = "(.*)(Firefox)$";
            opaque = true;
          }
          {
            name = "spotify-opaque";
            match.title = "(.*)(Spotify)(.*)$";
            opaque = true;
          }
        ];

        layer_rule = [
          {
            name = "waybar-blur";
            match.namespace = "waybar";
            blur = true;
          }
        ];

        workspace_rule = [
          {
            workspace = "name:${wsWeb}";
            monitor = "DP-3";
            default = true;
          }
          {
            workspace = "name:${wsTerm}";
            monitor = "DP-1";
            default = true;
          }
          {
            workspace = "name:${wsSysmon}";
            monitor = "HDMI-A-2";
            default = true;
          }
          {
            workspace = "name:${wsSteam}";
            monitor = "DP-1";
          }
        ];

        # exec-once has no lua spelling; the startup event is the equivalent.
        on = [
          {_args = ["hyprland.start" (mkLuaInline "function() hl.exec_cmd(\"waybar\") end")];}
          # kwallet ships no org.freedesktop.secrets activation file, so under
          # Hyprland nothing starts the Secret Service the way Plasma's portal
          # does; libsecret clients would find no provider at all.
          {_args = ["hyprland.start" (mkLuaInline "function() hl.exec_cmd(${luaStr (lib.getExe' pkgs.kdePackages.kwallet "ksecretd")}) end")];}
          {_args = ["workspace.created" spawnOnEmptyHandler];}
        ];
      };
    };

    programs.eww = {
      enable = false;
    };
    programs.wofi.enable = true;
    services.hyprpaper = {
      enable = false;
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
          "DP-3,/home/slwst/pics/wallpaper/catppuccin/buttons.png"
          "HDMI-A-2,/home/slwst/pics/wallpaper/catppuccin/dark-cat.png"
        ];
      };
    };
    # kanshi is deliberately off. It is a wlroots output daemon and duplicates
    # Hyprland's own `monitor` handling, and its profiles only match when every
    # connected output is covered by the profile - the HTC Vive connector always
    # breaks that, which is why it logged "no profile matched" and did nothing.
    # Monitor layout lives in wayland.windowManager.hyprland.settings.monitor above.
    services.kanshi.enable = false;
  });
}

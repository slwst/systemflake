{
  config,
  pkgs,
  inputs,
  ...
}: {
  services.polybar = {
    package = pkgs.polybar.override {
      pulseSupport = true;
      i3Support = true;
    };
    script = ''
      MONITOR=DP-0 polybar --reload main &
      MONITOR=HDMI-0 polybar --reload extra &
    '';
    extraConfig = builtins.readFile (pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "polybar";
        rev = "9ee66f83335404186ce979bac32fcf3cd047396a";
        sha256 = "bUbSgMg/sa2faeEUZo80GNmhOX3wn2jLzfA9neF8ERA=";
      }
      + "/themes/frappe.ini");
    settings = {
      "settings" = {
        screenchange-reload = true;
        pseudo-transparancy = false;
      };
      "bar/base" = {
        height = "30pt";
        radius = "20";
        background = "#aa303446";
        foreground = "\${colors.text}";
        offset-y = "0.5%";
        line-size = "5pt";
        border-size = "6px";
        border-color = "\${colors.transparent}";
        padding-left = 2;
        padding-right = 2;
        #module-margin = 1;
        separator = "|";
        separator-foreground = "\${colors.overlay1}";
        font-0 = "mononoki Nerd Font:style=Regular:size=16";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        enable-ipc = true;
      };
      "bar/main" = {
        "inherit" = "bar/base";
        monitor = "\${env:MONITOR:}";
        width = "100%";
        modules-left = "i3 xwindow";
        modules-center = "spotify";
        modules-right = "magicTrackpad dualsense pulseaudio memory cpu date";
      };
      "bar/extra" = {
        "inherit" = "bar/base";
        monitor = "\${env:MONITOR:}";
        width = "100%";
        modules-left = "i3";
      };
      "module/i3" = {
        type = "internal/i3";
        pin-workspaces = true;
        show-urgent = false;
        strip-wsnumbers = true;
        index-sort = true;
        enable-click = true;
        enable-scroll = false;

        label-focused-foreground = "\${colors.mauve}";
        label-focused-background = "\${colors.surface0}";
        label-focused-underline = "\${colors.teal}";

        label-unfocused-foreground = "\${colors.lavender}";
        label-unfocused-underline = "\${colors.text}";

        label-visible-foreground = "\${colors.lavender}";
        label-visible-underline = "\${colors.text}";
      };
      "module/dualsense" = import ./polybar-dualsense.nix pkgs;
      "module/magicTrackpad" = import ./polybar-magic-trackpad.nix pkgs;
      "module/spotify" = import ./polybar-spotify.nix pkgs;
      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = "\${colors.surface0}";
        label-active-underline = "\${colors.lavender}";

        label-occupied = "%name%";

        label-urgent = "%name%";
        label-urgent-background = "\${colors.red}";

        label-empty = "%name%";
        label-empty-foreground = "\${colors.transparent}";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title%";
        format-foreground = "\${colors.peach}";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume-prefix = "VOL ";
        format-volume-prefix-foreground = "\${colors.maroon}";
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-muted = "mute";
        label-muted-foreground = "\${colors.peach}";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.pink}";
        label = "%percentage_used:2%%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.flamingo}";
        label = "%percentage:2%%";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;

        date = "%Y-%m-%d %H:%M:%S";
        date-alt = "%I:%M %p";

        label = "%date%";
        label-foreground = "\${colors.rosewater}";
      };
    };
  };

  # startup w/ i3
  xsession.windowManager.i3.config.startup = [
    {
      command = "systemctl --user restart polybar";
      always = true;
      notification = false;
    }
  ];
}

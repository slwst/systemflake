{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+enter" = "launch --cwd=current";
    };
    settings = {
      #font_family = "mononoki Nerd Font Mono";
      font_family = "VictorMono Nerd Font Mono";
      font_size = "12.0";
      # Window
      background_opacity = "0.6";
      scrollback_lines = 10000;
      window_padding_width = 6;

      # Tabs
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Display
      sync_to_monitor = true;
    };
    #themeFile = "Catppuccin-Frappe";
  };
  home.file."sysmon" = {
    target = ".config/kitty/sysmon.session";
    text = ''
      layout splits
      launch htop
      launch --location=vsplit nvitop
      launch hyprctl dispatch "layoutmsg preselect d"
      launch hyprctl keyword "dwindle:default_split_ratio 1.7"
      launch hyprctl dispatch "exec glava"
      launch hyprctl keyword "dwindle:default_split_ratio 1.0"
      launch hyprctl dispatch "layoutmsg preselect r"
    '';
  };
}


#      launch hyprctl dispatch "focuswindow class:GLava"
#      launch hyprctl dispatch "resizeactive exact 100% 16%"

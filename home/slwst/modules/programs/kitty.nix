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
}

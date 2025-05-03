{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.services.waybar-hypr;
  waybar-hardware = builtins.fromJSON (builtins.readFile ./waybar-hardware.json);
  waybar-modules = builtins.fromJSON (builtins.readFile ./waybar-modules.json);
  waybar-quicklinks = builtins.fromJSON (builtins.readFile ./waybar-quicklinks.json);
in {
  options.modules.desktop.services.waybar-hypr = {
    enable = mkEnableOption "Adds waybar for more bar in your way";
  };

  config = mkIf cfg.enable ({
    catppuccin.waybar = {
      enable = true;
      flavor = "macchiato";
    };
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 16;
          spacing = 8;
          margn-top = 8;
          margn-left = 8;
          margn-right = 8;
          mode = "dock";
          output = [
            "DP-1"
            "HDMI-A-1"
          ];
          modules-left = [ "group/quicklinks" "tray" "hyprland/window" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [ "network" "group/hardware" "clock" "custom/notification" ];

        } // waybar-hardware // waybar-modules // waybar-quicklinks;
      };
      style = (builtins.readFile ./waybar.css);
    };
  });
}

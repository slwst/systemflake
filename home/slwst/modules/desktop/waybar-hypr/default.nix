{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.services.waybar-hypr;
  hardware = builtins.fromJSON (builtins.readFile ./hardware.json);
  modules = builtins.fromJSON (builtins.readFile ./modules.json);
  sound = builtins.fromJSON (builtins.readFile ./sound.json);
  quicklinks = builtins.fromJSON (builtins.readFile ./quicklinks.json);
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
          margin-top = 8;
          margin-left = 8;
          margin-right = 8;
          mode = "dock";
          output = [
            "DP-1"
            "HDMI-A-1"
          ];
          modules-left = [ "group/quicklinks" "tray" "hyprland/window" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [ "network" "group/sound" "group/hardware" "clock" "custom/notification" ];

        } // hardware // modules // quicklinks // sound;
      };
      style = (builtins.readFile ./waybar.css);
    };
  });
}

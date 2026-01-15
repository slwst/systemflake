{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.windowManager.sddm;
in {
  options.modules.nixos.windowManager.sddm= {
    enable = mkEnableOption "Enable the hyprland window manager";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        videoDrivers = ["nvidia"];
      };
      displayManager = {
        sddm = {
          enable = true;
#          package = pkgs.kdePackages.sddm;
          wayland = {
            enable = true;
          };
          /*
          settings = {
            Wayland = {
              SessionDir = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
            };
          };
          */
          setupScript = ''
            xrandr --output HDMI-0 --off
            xrandr --output DP-1 --auto --primary
          '';
        };
      };
    };
    security.pam.services.lightdm.u2fAuth = true;
    catppuccin.sddm = {
      enable = true;
      assertQt6Sddm = true;
      flavor = "macchiato";
      font = "VictorMono Nerd Font";
      fontSize = "12";
      loginBackground = true;
    };
    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_SESSION_TYPE = "wayland";
      };
    };
  };
}

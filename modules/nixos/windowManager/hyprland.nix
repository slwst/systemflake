{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.windowManager.hyprland;
in {
  options.modules.nixos.windowManager.hyprland= {
    enable = mkEnableOption "Enable the hyprland window manager";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      wl-clipboard
      slurp
      grim
      xorg.xrandr
      hyprland-qt-support
    ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    services = {
      xserver = {
        videoDrivers = ["nvidia"];
#        displayManager.setupCommands = "";
      };
      displayManager = {
        sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
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
            xrandr --output DP-1 --auto --primary
            xrandr --output HDMI-A-1 --brightness 0
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

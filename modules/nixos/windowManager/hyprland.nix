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
    ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    services = {
      xserver = {
        videoDrivers = ["nvidia"];
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
          catppuccin = {
            enable = true;
            assertQt6Sddm = true;
            flavor = "macchiato";
            font = "VictorMono Nerd Font";
            fontSize = "12";
            loginBackground = true;
          };
        };
      };
    };
    security.pam.services.lightdm.u2fAuth = true;
    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_SESSION_TYPE = "wayland";
      };
    };
  };
}

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
    };
  };
}

{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.windowManager.plasma6;
in {
  options.modules.nixos.windowManager.plasma6 = {
    enable = mkEnableOption "Enable the plasma6 desktop";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      wl-clipboard
      xorg.xrandr
      #kdePackages.sddm-kcm # Configuration module for SDDM
      hardinfo2 # System information and benchmarks for Linux systems
      vlc # Cross-platform media player and streaming server
      wayland-utils # Wayland utilities
      wl-clipboard # Command-line copy/paste utilities for Wayland
    ];

    services = {
      desktopManager.plasma6.enable = true;
      xserver = {
        videoDrivers = ["nvidia"];
#        displayManager.setupCommands = "";
      };
    };
  };
}

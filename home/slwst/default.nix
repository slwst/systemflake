{
  config,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home.nix
    ./packages.nix

    ./modules/shell
    ./modules/windowManager
    ./modules/programs
    ./modules/desktop
  ];
  config.modules = {
    #windowManager.hyprland.enable = false;
    windowManager.i3.enable = false;
    windowManager.sway.enable = true;
  };
}

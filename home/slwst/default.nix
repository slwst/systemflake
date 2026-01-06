{
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./home.nix
    ./packages.nix

    ./modules/shell
    ./modules/windowManager
    ./modules/programs
    ./modules/desktop
    ./modules/ai
  ];
  config.modules = {
    windowManager.hyprland.enable = true;
    windowManager.i3.enable = false;
    windowManager.sway.enable = false;

    ai.enable = true;
  };
}

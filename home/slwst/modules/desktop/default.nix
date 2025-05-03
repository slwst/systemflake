{
  imports = [
    ./feh.nix
    ./gtk.nix
    ./rofi.nix
    ./waybar-hypr.nix
    ./waybar-sway.nix
    ./swaylock.nix

    ./dunst
    ./polybar
  ];
  services.easyeffects.enable = true;
}


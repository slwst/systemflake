{
  imports = [
    ./feh.nix
    ./gtk.nix
    ./rofi.nix
    ./waybar-sway.nix
    ./swaylock.nix

    ./dunst
    ./polybar
    ./waybar-hypr
  ];
  services.easyeffects.enable = true;
}


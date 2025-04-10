{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.windowManager.i3;
in {
  options.modules.nixos.windowManager.i3 = {
    enable = mkEnableOption "Enable the i3 window manager";

    layout = mkOption {
      type = types.str;
      default = "us";
      description = "The keyboard layout to use for the X server.";
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      autorun = true;

      dpi = 109;
      exportConfiguration = true;
      xkb.layout = "${cfg.layout}";
      config = lib.mkAfter ''
        Section "InputClass"
         Identifier   "ds-touchpad"
         Driver       "libinput"
         MatchProduct "Wireless Controller Touchpad"
         Option       "Ignore" "True"
        EndSection
      '';
      displayManager = {
        lightdm = {
          enable = true;
          background = builtins.toPath (pkgs.fetchFromGitHub
            {
              owner = "catppuccin";
              repo = "wallpapers";
              rev = "0cea4a28451851a637762dec07ec4fb2bfebc421";
              sha256 = "B2ncT2qPc0inHHcO1BAZW5of+K0sIdtPcdpqcPUbKBo=";
            }
            + "/os/nix-black-4k.png");
          greeters.gtk = {
            enable = true;
            cursorTheme = {
              name = "Catppuccin-Frappe-Dark-Cursors";
              package = pkgs.catppuccin-cursors.frappeDark;
              size = 16;
            };
            iconTheme = {
              name = "Papirus-Dark";
            };
            theme = {
              name = "Catppuccin-Frappe-Standard-Teal-Dark";
            };
          };
        };
      };

      # TODO move non-default config items to user modules
      windowManager.i3.enable = true;
    };
    services.displayManager.defaultSession = "none+i3";
    services.libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };
    hardware.graphics = {
      enable = true;
      #driSupport = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
    };
    qt = {
      enable = true;
      style = "adwaita";
      platformTheme = "gnome";
    };
    security.pam.services.lightdm.u2fAuth = true;
    environment.systemPackages = with pkgs; [
      catppuccin-cursors.frappeDark
      (catppuccin-gtk.override {accents = ["teal"];})
      feh
      gtk2
      gtk3
      gtk4
      papirus-icon-theme
      skippy-xd
    ];
  };
}

{pkgs, ...}: {
  gtk = {
    enable = true;
    colorScheme = "dark";
    /*
    theme = {
      name = "Catppuccin-Frappe-Standard-Teal-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["teal"];
      };
    };
    */


    font = {
      name = "VictorMono Nerd Font";
      size = 12;
    };

    /*
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    */

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';

    cursorTheme = {
      package = pkgs.catppuccin-cursors.frappeDark;
      name = "Catppuccin-Frappe-Dark-Cursors";
    };
  };

  home.pointerCursor = {
    name = "Catppuccin-Frappe-Dark-Cursors";
    package = pkgs.catppuccin-cursors.frappeDark;
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  /*
  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Frappe-Standard-Teal-Dark";
  };
  */

  home.packages = with pkgs; [
    gnome-themes-extra
    #gtk-engine-murrine
    #gtk_engines
  ];
}

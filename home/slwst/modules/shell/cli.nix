{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    fd
    nnn
    ripgrep
  ];

  programs = {
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
    bat = {
      enable = true;
      #themes = {
      #  Catppuccin-frappe = {
      #    src = pkgs.fetchFromGitHub {
      #      owner = "catppuccin";
      #      repo = "bat";
      #      rev = "699f60fc8ec434574ca7451b444b880430319941";
      #      sha256 = "6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
      #    };
      #    file = "themes/Catppuccin Frappe.tmTheme";
      #  };
      #};
      #config.theme = "Catppuccin-frappe";
    };
  };
}

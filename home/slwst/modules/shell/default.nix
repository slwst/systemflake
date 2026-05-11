{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  browser = ["firefox.desktop"];

  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/discord" = ["WebCord.desktop"];
  };
in {
  imports = [
    ./cli.nix
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./nix.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];
  services = {
    udiskie.enable = false;
  };
  programs = {
    man.enable = true;
  };
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/other";
      download = "$HOME/download";
      videos = "$HOME/vids";
      music = "$HOME/music";
      pictures = "$HOME/pics";
      desktop = "$HOME/other";
      publicShare = "$HOME/other";
      templates = "$HOME/other";
      extraConfig = {
        XDG_DEVELOPMENT_DIR = "$HOME/dev";
      };
    };
    mimeApps.enable = true;
    mimeApps.associations.added = associations;
    mimeApps.defaultApplications = associations;
  };
}

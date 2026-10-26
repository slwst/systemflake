{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  browser = ["firefox.desktop"];
  mail = ["thunderbird.desktop"];

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
    "video/*" = ["mpv.desktop"];
    "image/*" = ["org.kde.gwenview.desktop"];
    "application/json" = browser;
    "application/pdf" = ["okularApplication_pdf.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];

    # Thunderbird and the Claude Code handler register these imperatively via
    # xdg-mime, which replaces the home-manager symlink and breaks activation.
    # Declaring them here keeps the file store-owned.
    "x-scheme-handler/mailto" = mail;
    "x-scheme-handler/mid" = mail;
    "x-scheme-handler/net.thunderbird" = mail;
    "message/rfc822" = mail;
    "x-scheme-handler/claude-cli" = ["claude-code-url-handler.desktop"];
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

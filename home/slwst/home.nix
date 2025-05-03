{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "slwst";
    homeDirectory = "/home/slwst";
    stateVersion = "22.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };
  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  programs.home-manager.enable = true;
}

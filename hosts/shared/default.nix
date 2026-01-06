{
  lib,
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./locale.nix
    ./system.nix
    ./nix.nix
    ./network.nix
    ./users.nix
    ./environment
    ./security
    ./services
  ];

  programs = {
    dconf.enable = true;
    nm-applet.enable = false;
    seahorse.enable = true;
  };

  services = {
    blueman.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    pcscd.enable = true;
    touchegg.enable = true;
    udisks2.enable = true;
  };
}

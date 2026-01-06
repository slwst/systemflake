{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.virtualization.libvirtd;
in {
  options.modules.nixos.virtualization.libvirtd = {
    enable = mkEnableOption "Enable The Libvirt Virtualization Daemon";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.virt-manager
      pkgs.spice
      pkgs.spice-gtk
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
  };
}

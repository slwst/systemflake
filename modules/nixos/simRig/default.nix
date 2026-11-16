{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.simRig;
in {
  options.modules.nixos.simRig = {
    enable = mkEnableOption "Enable sim racing rig support (Moza hardware, Boxflat)";
  };

  config = mkIf cfg.enable {
    # Boxflat ships 99-boxflat.rules in $out/lib/udev/rules.d, which is inert until
    # the package is listed here: services.udev.packages is what collects it into
    # /etc/udev/rules.d. That is also the only place Boxflat itself looks for the
    # rules, so installing the package alone makes it warn that they are missing.
    # The rule tags the Moza (vendor 346e) ttyACM device uaccess so a normal user
    # can talk to the wheelbase.
    services.udev.packages = [pkgs.boxflat];

    environment.systemPackages = with pkgs; [
      boxflat
    ];
  };
}

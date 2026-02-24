{
  config,
  pkgs,
  ...
}: {
  services = {
    dbus = {
      packages = with pkgs; [dconf gcr udisks2];
      enable = true;
    };
    journald.extraConfig = ''
      MaxRetentionSec = 3456000
    '';
    udev.packages = with pkgs; [
      gnome-settings-daemon
      keychron-udev-rules
      yubikey-personalization
      game-devices-udev-rules
    ];
  };

  environment.variables = {
    EDITOR = "hx";
    BROWSER = "firefox";
  };
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";
  console.earlySetup = true;
}

{
  pkgs,
  ...
}: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [53317];
      allowedTCPPorts = [22 80 5432 6443 8000 8080 11434 53317];
      allowPing = true;
      logReversePathDrops = true;
    };
    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      Settings = {
        AutoConnect = true;
      };
    };
  };
  # finish boot before connection establishes
  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;
}

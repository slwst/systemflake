{
  pkgs,
  ...
}: {
  networking = {
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [53317];
      allowedTCPPorts = [22 80 5432 6443 8000 8080 11434 53317];
      allowPing = true;
      logReversePathDrops = true;
    };
  };
  # finish boot before connection establishes
  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;
}

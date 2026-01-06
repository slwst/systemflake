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
      allowedTCPPorts = [22 80 5432 6443 8000 8080 11434];
      allowPing = true;
      logReversePathDrops = true;
    };
  };
  # finish boot before connection establishes
  systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;
}

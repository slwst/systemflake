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
      allowedTCPPorts = [22 80 6443 8080];
      allowPing = true;
      logReversePathDrops = true;
    };
  };
  # finish boot before connection establishes
  systemd.services.NetworkManager-wait-online.enable = false;
}

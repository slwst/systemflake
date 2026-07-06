{
  config,
  pkgs,
  lib,
  ...
}: {

  environment.etc."ssh/banner".text = ''
        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⠖⢶⣦⣄⡀⠀⢀⣴⣶⠟⠓⣶⣦⣄⡀⠀⠀⠀⠀⠀⣀⣤⣤⣀⡀⠀⠀⢠⣤⣤⣄⡀⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⣿⡄⠀⣿⠈⢻⣤⣾⠏⠀⠀⠀⠈⢷⡈⠻⣦⡀⠀⣠⣾⠟⠋⠀⠙⣿⣶⣴⠏⢠⣿⠋⠉⣷⡄⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠁⠈⣿⠀⣿⠃⢸⣿⡏⠀⠀⠀⠀⠀⢸⡻⣦⣹⣇⢠⣿⠃⠀⠀⠀⠀⠘⣇⠙⣧⡿⢁⣴⠞⠛⢿⡆⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠃⠀⠀⢹⣷⣿⣰⡿⢿⡇⠀⠀⠀⠀⠀⢸⢻⣜⣷⣿⣿⡇⠀⠀⠀⠀⠀⠀⣟⣷⣹⣁⡞⠁⠀⠀⠘⣿⡄⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⣿⡟⠀⠀⠀⠈⠉⢹⡟⠁⢸⡇⠀⠀⠀⠀⠀⢸⡆⠙⠃⢀⣿⠀⠀⠀⠀⠀⠀⠀⣿⠛⣿⠛⠀⠀⠀⠀⠀⢹⡇⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠈⣇⠀⢸⡇⠀⠀⠀⠀⠀⠀⣇⠀⠀⠘⣿⡄⠀⠀⠀⠀⠀⠀⢹⡀⢸⡇⠀⠀⠀⠀⠀⠘⣿⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⡀⢸⣷⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠸⣧⢸⣿⠀⠀⠀⠀⠀⠀⢿⡆
      ⠀⠀⠀⠀⣠⣤⣶⣶⣿⠿⢶⣶⣤⣄⠀⠀⠘⡇⠀⢻⡄⠀⠀⠀⠀⠀⠀⢳⡀⠀⢻⣧⠀⠀⠀⠀⠀⠀⠀⢿⣾⣿⠀⠀⠀⠀⠀⠀⢸⡇
      ⠀⠀⣴⣿⢟⣯⣭⡎⠀⠀⢀⣤⡟⠻⣷⣄⠀⢹⡄⢸⣇⠀⠀⠀⠀⠀⠀⠈⣷⡀⠘⣿⡄⠀⠀⠀⠀⠀⠀⠀⢿⡏⠀⠀⠀⠀⠀⠀⢸⣧
      ⢀⣾⢏⠞⠉⠀⠀⠀⠀⠀⠻⢿⣿⣀⠼⢿⣶⣶⣷⡀⣿⡀⠀⠀⠀⠀⠀⠀⢸⣇⠀⢻⣷⠀⠀⠀⠀⠀⠀⠀⠈⢿⣆⠀⠀⠀⠀⠀⢸⣿
      ⣸⡷⠋⠀⠀⠀⠀⣠⣶⣿⠦⣤⠄⠀⠀⠀⣿⣿⣦⡀⣿⠇⠀⠀⠀⠀⠀⠀⠀⢻⡀⠈⣿⡆⠀⠀⠀⠀⠀⠀⠀⠈⢻⣆⠀⠀⠀⠀⢸⣿
      ⣿⢁⡴⣾⣿⡆⠀⠙⢛⣡⡾⠋⠀⠀⠀⢠⠇⠈⠛⣿⠏⠀⠀⠀⠀⠀⠀⠰⣄⠸⡗⠛⢻⣿⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣆⠀⠀⠀⣼⣿
      ⢿⡞⠀⠈⢉⡇⠉⠉⠉⠉⠀⠀⠀⠀⣠⠊⠀⢀⡾⠋⠀⠀⠀⠀⠀⢀⡀⠀⣿⠳⠇⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⣿⡇
      ⠸⣷⠀⢠⠎⠀⠀⠀⠀⠀⠀⣀⠴⠋⠀⠖⠚⠋⠀⠀⠀⠀⠀⢀⡄⢸⣷⡀⣿⠀⠀⠀⣸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⢰⣿⠇
      ⠀⢻⣷⣯⣀⣀⣀⣀⣠⠤⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠿⣷⠇⠀⠀⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⣾⡟⠀
      ⠀⠈⢻⣷⡉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠃⠀
      ⠀⠀⠀⢻⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠃⠀⠀
      ⠀⠀⠀⠀⠙⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠇⠀⠀⠀
      ⠀⠀⠀⠀⠀⠈⠻⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠃⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⠟⠁⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣶⣦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣴⣶⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⡻⠿⠿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⣿⠿⠿⢛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                     ~hi

    '';
  services.openssh = {
    enable = true;
    openFirewall = true;
    ports = [22];
    settings = {
      Banner = "/etc/ssh/banner";
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = lib.mkForce false;
      PermitRootLogin = lib.mkForce "no";
      UseDns = false;
    };

    extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PasswordAuthentication no
        PermitTTY no
        X11Forwarding no
    '';

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/git-server";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9vuN/AfJ46kG8b1fPaDevQQcPmoP6Nsx8VB02o5w2qbSTyqEgqRRikLDvNtVaTDzPbiiXUzPebvB4VwVOlvKb7mg1GQhzrS7s1lc5j0IIpxEwKAolTb0tgn0W5KYRHwsILBUaplvL/mGVVV9OltuCdSjE12hPHuC/nlXcjbJKpHaLrF0nltAunMwIStw6inK8fXQnISpDRtGAcVkiN/voaCVCYRctVJvir0y4ZeTj9E3jceLygdXR0G74UxdJLKi5k6x0d1eln0Z7a6Q+AnuA5rBM6Oi4gsWZcqGXHCxRLLd1/qa3P2dSOW0FlXdGbQcTfE1tEFhuD41RR6n27hXBVfXOJOnyT1X+cHv/74BD6J1bYCyzDxCUi3dYmYEZPZJWuPoISyAXFK3pvKhRwEjhIX+2HbypMNiKnELOX6w5mvcOID4D+415w8Vi9hIDsDuUWrFFeuJN48j9YDvE8EPEeXfyUnQBUNLHL05Rwi8hOC7mXtJeEW6Lyh86VCbAMLZOi5gz/FgEHNLwfBBsJjADWD8rMgf64MiynIoOculk/GAytD6dLixzO9AcvW5Sh/t+36G0M2OxHjABYkBilCzllIrg9+VJ7qfsIouOdzU88lpbOyoDiExmeyAXBU4KtmywXmwfg6uPjymqOshGij5QYvg3bZncyGTFgVLtw/0SNQ== cardno:9_728_578"
    ];
  };
  users.groups.git = {};


  # block repeated failed attempts
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0/8"
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];
  };

  # enable mosh
  /*
  programs.mosh = {
    enable = true;
    withUtempter = true;
  };
  */
}

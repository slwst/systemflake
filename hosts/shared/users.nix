{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = true;
  users.users.slwst = {
    description = "slwst";
    isNormalUser = true;
    #shell = pkgs.fish;
    shell = pkgs.zsh;
    initialPassword = "butts";
    extraGroups =
      [
        "wheel"
        "systemd-journal"
        "audio"
        "video"
        "input"
        "networkmanager"
        "disk"
      ]
      ++ ifTheyExist [
        "docker"
        "gamemode"
        "git"
        "kvm"
        "libvirt"
        "libvirtd"
        "openrazer"
      ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9vuN/AfJ46kG8b1fPaDevQQcPmoP6Nsx8VB02o5w2qbSTyqEgqRRikLDvNtVaTDzPbiiXUzPebvB4VwVOlvKb7mg1GQhzrS7s1lc5j0IIpxEwKAolTb0tgn0W5KYRHwsILBUaplvL/mGVVV9OltuCdSjE12hPHuC/nlXcjbJKpHaLrF0nltAunMwIStw6inK8fXQnISpDRtGAcVkiN/voaCVCYRctVJvir0y4ZeTj9E3jceLygdXR0G74UxdJLKi5k6x0d1eln0Z7a6Q+AnuA5rBM6Oi4gsWZcqGXHCxRLLd1/qa3P2dSOW0FlXdGbQcTfE1tEFhuD41RR6n27hXBVfXOJOnyT1X+cHv/74BD6J1bYCyzDxCUi3dYmYEZPZJWuPoISyAXFK3pvKhRwEjhIX+2HbypMNiKnELOX6w5mvcOID4D+415w8Vi9hIDsDuUWrFFeuJN48j9YDvE8EPEeXfyUnQBUNLHL05Rwi8hOC7mXtJeEW6Lyh86VCbAMLZOi5gz/FgEHNLwfBBsJjADWD8rMgf64MiynIoOculk/GAytD6dLixzO9AcvW5Sh/t+36G0M2OxHjABYkBilCzllIrg9+VJ7qfsIouOdzU88lpbOyoDiExmeyAXBU4KtmywXmwfg6uPjymqOshGij5QYvg3bZncyGTFgVLtw/0SNQ== cardno:000609728578"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKndwAZ6zY7guONvswJaGOqzgGNs1IIA5pVALFnyo9Y4T0Q3FnhynrAtnKeT6oUU6IuOKYBY8+RCcZ+aY2fD5Bw= slwst@ipad"
    ];
  };
}

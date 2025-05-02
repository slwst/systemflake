{
  config,
  lib,
  pkgs,

  ...
}: {
  imports = [
    ./hardware-configuration.nix

    # shared config
    ../shared
  ];

  boot = {
    # latest kernel
#      kernelPackages = pkgs.linuxPackages_latest;
#      kernelPackages = pkgs.linuxPackages_zen;
      kernelPackages = pkgs.linuxPackages_xanmod_stable;

    kernelParams = [
      "quiet"
    ];

    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["btrfs"];
    };
    extraModprobeConfig = ''
      options usbcore use_both_schemes=y
    '';
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
    i2c.enable = true;
    openrazer.enable = true;

  };

  services = {
    btrfs.autoScrub.enable = true;
    acpid.enable = true;
    #thermald.enable = true;
    upower.enable = true;
    hardware.openrgb = {
      enable = false;
      motherboard = "intel";
      package = pkgs.openrgb-with-all-plugins;
    };
    #[TODO] k3s move into module
    k3s = {
      enable = true;
      role = "server";
      extraFlags = toString [
        "--write-kubeconfig-mode 0644"
#        "--container-runtime-endpoint unix:///run/podman/podman.sock"
      ];
    };
    pulseaudio.enable = false;
  };

  systemd.services.k3s.wantedBy = lib.mkForce [ ];

  environment = {
    systemPackages = with pkgs; [
      acpi
      brightnessctl
      gcc
      k3s
      libva-utils
      ocl-icd
      vulkan-tools
    ];
  };

  modules.nixos = {
    bootloader.grub = {
      enable = true;
      efiSysMountPoint = "/boot";
      device = "nodev";
    };

    hardware.nvidia.enable = true;
    steam.enable = true;

    ai.enable = false;

    virtualization = {
      docker = {
        enable = true;
        enableNvidia = true;
      };

      libvirtd.enable = true;

      podman = {
        enable = true;
        enableNvidia = false;
      };
    };

    windowManager.hyprland = {
      enable = false;
    };

    windowManager.i3 = {
      enable = false;
      layout = "us";
    };
    windowManager.sway = {
      enable = true;
    };
  };

  system.stateVersion = lib.mkForce "22.11";
}

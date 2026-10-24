{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = false;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    extraConfig = {
      client = {
        "99-no-rt" = {
          "context.properties" = {
            "module.rt" = false;
          };
        };
      };
      pipewire = {
        "92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 512;       # 10.7 ms default
            "default.clock.min-quantum" = 256;   # 5.3 ms floor
            "default.clock.max-quantum" = 2048;  # headroom to recover from xruns
          };
        };
      };
    };
  };

  systemd.user.services = {
    pipewire.wantedBy = ["default.target"];
    pipewire-pulse.wantedBy = ["default.target"];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.steam;
in {
  options.modules.nixos.steam = {
    enable = mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      #capSysNice = true;
    };
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs': with pkgs'; [
          libxcursor
          libxi
          libxinerama
          libxscrnsaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib # Provides libstdc++.so.6
          libkrb5
          keyutils
          # Add other libraries as needed
        ];
      };
    };
    programs.gamemode.enable = true;
    hardware = {
      steam-hardware.enable = true;
      graphics.enable = true;
      graphics.enable32Bit = true;
    };
      # work around for issue with capSysNice not working in gamescope.  even though it still
    # complains that it doesn't have cap nice ability to set it its own nice value.  ananicy
    # is setting it -20 (highest priority).  this could probably go into its own config since
    # ananicy-rules-cachyos has quality of life rules for a lot more then just gamescope.
    # and games.
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    boot.kernelParams = [
      "split_lock_detect=off"
      "clearcpuid=514"
    ];

    environment = {
      sessionVariables = rec {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        PATH = [
          "\${XDG_BIN_HOME}"
        ];
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
      };

      systemPackages = with pkgs; [
        protonup-ng
        game-devices-udev-rules
        gamescope-wsi
        steamcmd
        SDL2
        mangohud
        steamtinkerlaunch
        wine
        wine64
        wmctrl
        python3
      ];
    };
  };
}

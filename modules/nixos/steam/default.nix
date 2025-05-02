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
      capSysNice = true;
    };
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      extraPackages = with pkgs; [
        mumble
        openssl_1_1
      ];
    };
    programs.gamemode.enable = true;
    hardware.steam-hardware.enable = true;

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
      };

      systemPackages = with pkgs; [
        protonup
        steamcmd
        SDL2
        protontricks
        lutris
        mangohud
        wine
        wine64
        winetricks
        wmctrl
        python3
      ];
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ai;
in {
  options.modules.ai= {
    enable = mkEnableOption "Enable AI stack";
  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      host = "0.0.0.0";
      acceleration = "cuda";
      /*
      loadModels = [
        "gpt-oss:20b"
        "embeddinggemma:300m"
        "nomic-embed-txt:v1.5"
      ];
      */
    };
    home.packages = with pkgs; [
      claude-code
      claude-monitor
      gemini-cli-bin
      tmux
    ];
  };
}

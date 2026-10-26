{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh= {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    syntaxHighlighting.enable = true;

    initContent =
      let zshConfig = lib.mkOrder 1000
''# --- Gas Town Integration (managed by gt) ---
[[ -f /home/slwst/.config/gastown/shell-hook.sh ]] && source /home/slwst/.config/gastown/shell-hook.sh
# --- End Gas Town --- '';
      in lib.mkMerge [ zshConfig ];
   
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      dots = "hx ~/.systemflake";
      nhoss = "nh os switch ~/.systemflake#";
      cat = "bat";
      k = "kubectl";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["pkill *"];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
        "git"
      ];
    };
  };
  home.shell.enableZshIntegration = true;
}

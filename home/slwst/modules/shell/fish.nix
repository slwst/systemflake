{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    functions = {
      mmdoc = ''
        mmdc -w 1024 -H 768 -i ./$argv[1].mmd -o $argv[1].png && feh $argv[1].png &
      '';
      # Place this in your Fish functions folder to make it available immediately
      # e.g. ~/.config/fish/functions/envsource.fish
      #
      # Usage: envsource <path/to/env>
      envsource = ''
        for line in (cat $argv | grep -v '^#')
          set item (string split -m 1 '=' $line)
          set -gx $item[1] $item[2]
          echo "Exported key $item[1]"
        end
      '';
      fish_greeting = ''
        status --is-login
        if [ $status != 0 ]
          ${pkgs.nitch}/bin/nitch
        end
      '';
      gitignore = "curl -sL https://gitignore.io/api/$argv";
      #starship_transient_prompt_func = "starship module character";
      #starship_transient_rprompt_func = "starship module time";
      dots = "hx ~/.systemflake";
      goflake = "nix flake init -t github:nix-community/gomod2nix#app";
      nrs = "sudo nixos-rebuild switch --flake ~/.systemflake#";
      nrsi = "sudo nixos-rebuild switch --flake ~/.systemflake# --impure";
      nhoss = "nh os switch ~/.systemflake#";
    };
    shellAliases = {
      cat = "bat";
      k = "kubectl";
      ssh = "kitty +kitten ssh";
      newbg = "systemctl --user start feh-random-bg";
      k3sUse = "set -l KUBECONFIG /etc/rancher/k3s/k3s.yaml";
      xc = "xclip -selection clipboard";
    };
    /*
      enable_transience
      # enable transient prompt with starship
      bind \r transient_execute
    */
    interactiveShellInit = ''
      # direnv
      direnv hook fish | source
    '';
    plugins = [
      {
        name = "colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "colored_man_pages.fish";
          rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
          sha256 = "ii9gdBPlC1/P1N9xJzqomrkyDqIdTg+iCg0mwNVq2EU=";
        };
      }
    ];
  };
  home.packages = with pkgs; [
    fishPlugins.sponge
    fishPlugins.fzf-fish
    fishPlugins.forgit
  ];
}

{pkgs, ...}: {
  environment = {
    binsh = "${pkgs.bash}/bin/bash";
    shells = with pkgs; [zsh fish];

    pathsToLink = [ "/share/zsh" ];

    loginShellInit = ''
      dbus-update-activation-environment --all
    '';
  };
  programs.fish.enable = true;
  programs.zsh.enable = true;
}

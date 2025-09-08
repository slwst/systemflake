{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      extensions = [
        pkgs.vscode-extensions.catppuccin.catppuccin-vsc
      ];
    };
  };
}

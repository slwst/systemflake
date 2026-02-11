{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
  };

  programs.chromium= {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
}

{
  pkgs,
  ...
}:
  {
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-bin;
    profiles = {
      slwst = {
        isDefault = true;
        withExternalGnupg = true;
      };
    };
    settings = {
      "privacy.donottrackheader.enabled" = true;
    };
  };
}

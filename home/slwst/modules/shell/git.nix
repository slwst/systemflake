{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      key = "AD52C5FB3EFECC7A";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "slwst";
        email = "email@slw.st";
      };
      init = {defaultBranch = "main";};
    };
  };
}

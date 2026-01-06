{
  pkgs,
  lib,
  config,
  ...
}: {
  programs = {
    gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      settings = {
        personal-cipher-preferences = ["AES256" "AES192" "AES"];
        personal-digest-preferences = ["SHA512" "SHA384" "SHA256"];
        #personal-compression-preferences = [ "ZLIB" "BZIP2" "ZIP" "Uncompressed" ];
        default-preference-list = ["SHA512" "SHA384" "SHA256" "AES256" "AES192" "AES" "ZLIB" "BZIP2" "ZIP" "Uncompressed"];
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        with-key-origin = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
        default-key = "0xAD52C5FB3EFECC7A";
        trusted-key = "0xAD52C5FB3EFECC7A";
        keyserver = [
          "hkps://keys.openpgp.org"
        ];
      };
    };
  };
  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-rofi;
      enableSshSupport = true;
      enableFishIntegration = true;
    };
  };
}

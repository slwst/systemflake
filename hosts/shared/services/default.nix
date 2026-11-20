{
  imports = [
    ./openssh.nix
    ./pipewire.nix
    ./plymouth.nix
  ];
  # No gnome-keyring: KWallet/ksecretd owns org.freedesktop.secrets instead.
  # Both implement the Secret Service, and whichever registered the name first
  # won, which split secrets across two stores between boots. The real secrets
  # (browser safe-storage keys, NetworkManager PSKs) live in kdewallet, and the
  # gnome login.keyring was empty. See ksecretd's startup in hyprland.nix.
}

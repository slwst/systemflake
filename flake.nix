{
  description = "slwst NixOS configuration";
  # https://dotfiles.slw.st

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    helix.url = "github:helix-editor/helix";
    #llama-cpp.url = "github:ggerganov/llama.cpp";
    catppuccin.url = "github:catppuccin/nix";

    eve-preview-manager.url = "github:h0lylag/EVE-Preview-Manager";

    # Agentic devshell: herdr, beads, openspec, claude, opencode. The agent toolchain is pinned
    # by devflake's own lock, so its nixpkgs deliberately does not follow ours.
    devflake.url = "github:slwst/devflake/v0.2.0";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    blender-bin.url = "https://flakehub.com/f/edolstra/blender-bin/1.0.21";
  };
  outputs = {
    self,
    nixpkgs,
    catppuccin,
    blender-bin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowBroken = true;
        allowUnfree = true;
        cudaSupport = true;
        cudaCapabilities = [ "8.9" ];
        cudaForwardCompat = false;
        tarball-ttl = 0;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
        nvidia.acceptLicense = true;
      };
      overlays = [
        blender-bin.overlays.default
      #(inputs.llama-cpp.overlays.default)
      (final: prev: {
        blender-bin = blender-bin.packages.${system}.default;
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
      ];
    }; 
    in rec
    {
      inherit lib pkgs;

      # modules
      nixosModules = import ./modules/nixos;
      # nixos configs
      nixosConfigurations = import ./hosts {inherit inputs outputs;};

      # dev shell for (direnv)
      devShells.${system}.default = inputs.devflake.lib.mkShell {
        inherit pkgs;
        # herdr workspace label, and the prefix this project's agents are named with
        name = "systemflake";
        packages = with pkgs; [
          alejandra
          git
          nix-prefetch-github
        ];
      };

      # use alejandra as formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}

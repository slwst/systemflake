{
  description = "slwst NixOS configuration";
  # https://dotfiles.slw.st

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    helix.url = "github:helix-editor/helix";
    llama-cpp.url = "github:ggerganov/llama.cpp";

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
    /*
    pyfa = {
      url = "path:/home/slwst/dev/nix/pyfa";
    };
    */

  };
  outputs = {
    self,
    nixpkgs,
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
        cudaForwardCompat = true;
        tarball-ttl = 0;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
        nvidia.acceptLicense = true;
      };
      overlays = [
      (inputs.llama-cpp.overlays.default)
      /*
      (final: prev: {
        lsp-ai = final.callPackage ./pkgs/lsp-ai { };
      })
      */
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
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git
          nix-prefetch-github
        ];
        name = "dotfiles";
      };

      # use alejandra as formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}

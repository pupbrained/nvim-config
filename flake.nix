{
  description = "A nixvim configuration";

  inputs = {
    codeium.url = "github:jcdickinson/codeium.nvim";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    codeium,
    flake-utils,
    nixpkgs,
    nixvim,
    treefmt-nix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [codeium.overlays.${system}.default];
      };

      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ./config;
      };
    in {
      formatter = treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          stylua.enable = true;
        };
      };

      checks.default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        inherit nvim;
        name = "My nixvim configuration";
      };

      packages.default = nvim;

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          nvfetcher
          stylua
        ];
      };
    });
}

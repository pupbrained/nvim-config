{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixvim.url = "github:pupbrained/nixvim-ocamllsp";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
    ...
  } @ inputs: let
    config = import ./config;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      nixvimLib = nixvim.lib.${system};
      overlays = with inputs; [neovim-nightly-overlay.overlay];
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      nixvim' = nixvim.legacyPackages.${system};
      nvim = nixvim'.makeNixvimWithModule {
        inherit pkgs;
        module = config;
      };
    in {
      formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      checks.default = nixvimLib.check.mkTestDerivationFromNvim {
        inherit nvim;
        name = "My nixvim configuration";
      };

      packages.default = nvim;

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nvfetcher
        ];
      };
    });
}

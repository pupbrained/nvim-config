{
  description = "A nixvim configuration";

  inputs = {
    codeium.url = "github:jcdickinson/codeium.nvim";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-utils,
    ...
  } @ inputs: let
    config = import ./config;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      nixvimLib = nixvim.lib.${system};
      overlays = with inputs; [codeium.overlays.${system}.default neovim-nightly-overlay.overlay];
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
      formatter = inputs.treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          stylua.enable = true;
        };
      };

      checks.default = nixvimLib.check.mkTestDerivationFromNvim {
        inherit nvim;
        name = "My nixvim configuration";
      };

      packages.default = nvim;

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          nvim
          nvfetcher
          stylua
        ];
      };
    });
}

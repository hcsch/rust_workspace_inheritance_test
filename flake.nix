{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nativeBuildInputs = with pkgs; [
          cargo
          rustc
        ];
        buildInputs = with pkgs; [
        ];
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          name = "rust_workspace_inheritance_test";
          version = "1.0";
          src = ./.;

          cargoHash = "sha256-m75JS8DR8ofXS0kREYNApsC3BwnG0uFQPpvwK76O/vM=";

          inherit buildInputs nativeBuildInputs;
        };

        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;
        };
      }
    );
}

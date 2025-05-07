{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs, fenix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nativeBuildInputs = with pkgs; [
          rustc
          cargo
          pkg-config

          llvmPackages.clangUseLLVM
          mold
        ];
        buildInputs = with pkgs; [ 
          udev alsa-lib-with-plugins vulkan-loader

          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr

          libxkbcommon
          wayland
        ];
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          name = "rust_workspace_inheritance_test";
          version = "1.0";
          src = ./.;

          cargoHash = "sha256-tXr4dxqAtwDyOxCT5645PxuBvICjgaWSry/hAVxYIg8=";
        };

        devShells.default = pkgs.mkShell.override {
          stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.clangStdenv;
        } pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
        };
      }
    );
}

{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        version = "0.0.0"; # TODO
        inherit (self) outputs;
        nativeBuildInputs = [
            pkgs.cmake
            pkgs.extra-cmake-modules
            pkgs.libffi
            pkgs.pkg-config
          ];
        buildInputs = [
            pkgs.luajit_2_1
            pkgs.wayland
            pkgs.wayland-scanner
            pkgs.xorg.libX11
          ];
      in {
        packages.lib = pkgs.stdenv.mkDerivation {
          pname = "neoclip-lib";
          inherit version;

          src = ./src;

          inherit nativeBuildInputs;
          inherit buildInputs;

          cmakeFlags = [];

          buildPhase = ''
            cmake -S $src -B build
            cmake --build build
          '';

          installPhase = ''
            mkdir $out
            strip -s build/*.so
            mv build/*.so $out
          '';

          meta = with pkgs.lib; {
            homepage = "https://github.com/matveyt/neoclip";
            description = "Multi-platform clipboard provider for neovim w/o extra dependencies";
            licencse = licenses.unlicense;
            platforms = platforms.all;
            maintainers = ["slava.istomin@tuta.io"];
          };
        };

        packages.default = pkgs.vimUtils.buildVimPlugin {
          pname = "neoclip";
          inherit version;

          src = ./.;

          installPhase = ''
            mv doc/ lua/ $out
          '';

          postInstallPhase = ''
            cp "${outputs.lib}/*" $out
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = nativeBuildInputs ++ buildInputs;

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        };
      }
    )
    // {
      overlays.default = self: pkgs: {
        hello = self.packages."${pkgs.system}".hello;
      };
    };
}

{
  stdenv, pkgs, lib,
  cmake, extra-cmake-modules, pkg-config,
  luajit_2_1, wayland, wayland-scanner, xorg,
  version, src
}:
lib.makeScope pkgs.newScope (self: {
  neoclip-lib = stdenv.mkDerivation {
    version = "0.0.0"; # TODO

    pname = "neoclip-lib";

    src = "${src}/src";

    # things used in the build go in here
    nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];
    # libraries used by the resulting program go in here
    buildInputs = [ luajit_2_1 wayland wayland-scanner xorg.libX11 ];

    cmakeFlags = [];

    buildPhase = ''
      cmake -S $src -B build
      cmake --build build
      '';

    installPhase = ''
      cmake --install build --strip --prefix $out
      '';

    meta = {
      homepage = "https://github.com/matveyt/neoclip";
      description = "Multi-platform clipboard provider for neovim w/o extra dependencies";
      license = lib.licenses.unlicense;
      platforms = lib.platforms.all;
      maintainers = ["slava.istomin@tuta.io"];
    };
  };

  neoclip-lua-only = pkgs.vimUtils.buildVimPlugin {
    pname = "neoclip";
    inherit version;
    inherit src;

    unpackPhase = ''
      cp -r $src/{lua,doc} .
    '';
  };

  neoclip = self.neoclip-lua-only.overrideAttrs {
    dependencies = [ self.neoclip-lib ];
  };
})

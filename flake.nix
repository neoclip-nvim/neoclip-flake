{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.neoclip.url = "github:neoclip-nvim/neoclip";
  inputs.neoclip.flake = false;

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  } @ inputs:
    let
      out = system:
        let
          pkgs' = nixpkgs.legacyPackages.${system};
          pkgs = pkgs'.extend self.overlays.default;
        in {
          packages.default = pkgs.vimPlugins.neoclip;
          checks.default = pkgs.callPackage ./test.nix {};
        };
    in
    utils.lib.eachDefaultSystem out
    // {
      overlays.default = final: prev:
        let scope = final.callPackage ./scope.nix {
          src = inputs.neoclip;
          version = "0.0.0";
        };
        in {
          vimPlugins.neoclip = scope.neoclip;
        };
    };
}

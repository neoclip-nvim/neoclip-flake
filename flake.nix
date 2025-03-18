{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.neoclip.url = "github:matveyt/neoclip";
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
          pkgs = nixpkgs.legacyPackages.${system};
          appliedOverlay = self.overlays.default pkgs pkgs;
        in {
          packages.default = appliedOverlay.vimPlugins.neoclip;
        };
    in
    utils.lib.eachDefaultSystem out
    // {
      overlays.default = final: prev:
        let scope = final.callPackage ./scope.nix {
          src = inputs.neoclip;
          version = "2025.03.17";
        };
        in {
          vimPlugins.neoclip = scope.neoclip;
        };
    };
}

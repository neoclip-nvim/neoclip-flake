{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neoclip.url = "../..";
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
    nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
      plugins = [{
        plugin = inputs.neoclip.packages.${system}.default;
        config = /* vim */ ''
          lua require('neoclip'):setup()
          checkhealth neoclip
        '';
      }];
    };
  in {
    packages.${system}.default = nvim;
  };
}

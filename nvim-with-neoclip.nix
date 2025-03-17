{
  pkgs
}:
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  plugins = [{
    plugin = pkgs.vimPlugins.neoclip;
    config = /* vim */ ''
      lua require('neoclip'):setup()
    '';
  }];
}

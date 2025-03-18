{
  pkgs
}:
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  plugins = [{
    plugin = pkgs.vimPlugins.neoclip;
    config = /* vim */ ''
      lua require('neoclip'):setup()
      vim.cmd('checkhealth neoclip | w! /tmp/health | qa!')
    '';
  }];
}

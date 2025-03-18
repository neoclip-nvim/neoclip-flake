{ testers }:

testers.runNixOSTest {
  name = "neoclip";
  nodes.machine = { config, pkgs, ... }:
  let
    nvim = pkgs.callPackage ./nvim-with-neoclip.nix {};
    session = {
      manage = "desktop";
      name = "nvim-test";
      start = ''
        ${pkgs.neovim}/bin/nvim &
        waitPID=$!
        '';
      };
  in
  {
    environment.systemPackages = [nvim];

    services.xserver.enable = true;
    services.xserver.displayManager.session = [
      session
    ];
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.xterm.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "alice";
    services.displayManager.defaultSession = "xterm";

    users.users.alice = {
      isNormalUser = true;
      password = "";
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
        uid = 1000;
    };

    system.stateVersion = "23.11";
  };

  testScript = /* python */ ''
    machine.start()
    # machine.succeed('nvim')
  '';
}

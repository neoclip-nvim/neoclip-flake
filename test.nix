{ testers }:

testers.runNixOSTest {
  name = "neoclip";
  nodes.machine = { config, pkgs, ... }:
  let
    nvim = pkgs.callPackage ./nvim-with-neoclip.nix {};
  in
  {
    environment.systemPackages = [nvim];

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.xterm.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "alice";

    users.users.alice = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
        uid = 1000;
    };

    system.stateVersion = "23.11";
  };

  testScript = /* python */ ''
    machine.start()
    machine.send_chars("root\n\n")
    # machine.succeed('nvim')
  '';
}

{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  services = {
    xserver = {
      enable = true;
      enableTCP = true;
      exportConfiguration = true;
      logFile = "/var/log/Xorg.0.log";
      # verbose = 7;
    };
  };
}

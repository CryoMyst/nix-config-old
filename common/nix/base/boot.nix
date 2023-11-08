{ pkgs, home-manager, userConfig, ... }: {
  imports = [ ./../base/user.nix ./../base/home-manager.nix ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 20;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };
}

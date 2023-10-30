{ config, pkgs, ... }:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services = {
        sddm.enableGnomeKeyring = true;
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };
  };
}
{ config, pkgs, ... }:
{
  programs = {
    dconf.enable = true;
    noisetorch.enable = true;
    zsh.enable = true;
    nix-ld.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}

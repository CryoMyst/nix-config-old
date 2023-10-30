{ config, pkgs, ... }:
{
  environment = {
    shells = [
      pkgs.zsh
    ];
    sessionVariables = { 
      GTK_THEME = "Adwaita:dark"; 
    };
  };
}
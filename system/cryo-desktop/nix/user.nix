{ config, pkgs, userConfig, ... }:
{  
  users.groups = {
    "flakemanager" = {};
  };
  users.users = {
    ${userConfig.username} = {
      isNormalUser = true;
      description = "CryoMyst";
      shell = pkgs.zsh;
      extraGroups = [ 
        "networkmanager" 
        "wheel" 
        "docker"
        "libvirtd"
        "flakemanager"
      ];
    };
  };
}
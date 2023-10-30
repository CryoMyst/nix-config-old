{ config, pkgs, userConfig, ... }:
{  
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
      ];
    };
  };
}
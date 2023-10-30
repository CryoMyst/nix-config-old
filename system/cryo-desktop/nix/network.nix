{ config, pkgs, computerConfig, ... }:
{
  networking = {
    hostName = computerConfig.hostname;
    networkmanager.enable = true;
  };
}
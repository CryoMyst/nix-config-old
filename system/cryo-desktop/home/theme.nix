{ config, pkgs, home-manager, userConfig, ... }:
{
  home-manager.users = {
    ${userConfig.username} = {

    };
  };
}
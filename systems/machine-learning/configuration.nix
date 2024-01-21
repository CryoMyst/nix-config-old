{ lib, pkgs, home-manager, user-config, ... }:
let
in
{
  imports = [
    ./hardware-configuration.nix
    ./../../nix/modules.nix
  ];

  cryo = {
    username = "cryomyst";
    hostname = "machine-learning";
    features = {
      nix.enable = true;
      boot.enable = true;
      home-manager.enable = true;
      network.enable = true;
      user.enable = true;
      direnv.enable = true;
      tmux.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      ssh.enable = true;
      terminal.enable = true;
      graphics.gpu = "nvidia";
      nvim.setup = "cryo";
      docker = {
        enable = true;
        nvidia = true;
      };
    };
    personal = {
      shares = {
        ram = true;
        rem = true;
      };
      ssh = {
        enable = true;
      };
    };
  };

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    dbus.enable = true;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 32*1024;
  }];
}

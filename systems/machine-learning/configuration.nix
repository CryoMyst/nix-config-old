{ lib, pkgs, home-manager, user-config, ... }:
let
in
{
  imports = [
    ./hardware-configuration.nix
    ./../../nix/modules.nix
  ];

  networking.firewall.enable = lib.mkForce false;
  cryo = {
    username = "cryomyst";
    hostname = "machine-learning";
    features = {
      nix.enable = true;
      boot.enable = true;
      home-manager.enable = true;
      network.enable = true;
      graphics.enable = true;
      graphics.gpu = "nvidia";
      user.enable = true;
      direnv.enable = true;
      tmux.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      ssh.enable = true;
      terminal.enable = true;
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
        cryomyst = true;
      };
    };
  };

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
  };

  services = {
    dbus.enable = true;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 32*1024;
  }];
}

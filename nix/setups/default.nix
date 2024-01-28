{ lib, pkgs, config, ... }:
{
  imports = [
    ./development
    ./laptop
    ./social
    ./terminal
    ./sway
  ];
}
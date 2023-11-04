{ pkgs, ... }:
{
  imports = [
    ./../terminal/zsh.nix
    ./../terminal/direnv.nix
    ./../terminal/neovim.nix
  ];
}
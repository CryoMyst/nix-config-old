{ pkgs, ... }: {
  imports  = [
    ./base/base.nix
    ./boot/boot.nix
    ./fonts/fonts.nix
    ./graphics/graphics.nix
    ./home-manager/home-manager.nix
    ./locale/locale.nix
    ./network/network.nix
    ./user/user.nix
  ];
}

{ ... }: {
  imports = [
    ./bluetooth
    ./docker
    ./libvirt
    ./network
    ./sound
    ./ssh
    ./strongswan
    ./swayidle
    ./wayvnc
    ./xserver
    ./yubikey
  ];
}
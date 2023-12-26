{ pkgs, ... }:
let
  system = pkgs.system;

  x86Desktop = with pkgs; [
    # x86 only desktop applications
    winetricks
    wineWowPackages.stagingFull
    (lutris.override {
      extraPkgs = pkgs: [
        winetricks
        wineWowPackages.staging
        libnghttp2
        jansson
      ];
    })
  ];

  desktop = with pkgs; [
    # Always included desktop applications
    firefox
    obs-studio
    obsidian
    remmina
    freerdp
    parsec-bin
    gnome.file-roller
    moonlight-qt
    pavucontrol
    thunderbird
  ];

in
  if system == "x86_64-linux" then
    desktop 
      ++ x86Desktop
  else
    desktop

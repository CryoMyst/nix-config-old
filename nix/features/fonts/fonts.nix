{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.fonts;
in {
  options.cryo.features.fonts = {
    enable = mkEnableOption "Enable fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        corefonts
        ubuntu_font_family
        powerline-fonts
        font-awesome
        source-code-pro
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        emojione
        kanji-stroke-order-font
        ipafont
        liberation_ttf
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        jetbrains-mono
      ];
    };
  };
}
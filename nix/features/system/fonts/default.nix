{ lib, pkgs, config, home-manager, ... }:
with lib;                      
let
  cryo = config.cryo;
  cfg = config.cryo.features.system.fonts;
in {
  options.cryo.features.system.fonts = {
    enable = mkEnableOption "Enable fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      fontconfig.enable = true;
      packages = with pkgs; [
        corefonts
        dina-font
        emojione
        font-awesome
        ipafont
        jetbrains-mono
        kanji-stroke-order-font
        liberation_ttf
        mplus-outline-fonts.githubRelease
        nerdfonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        powerline-fonts
        proggyfonts
        source-code-pro
        ubuntu_font_family
      ];
    };
  };
}
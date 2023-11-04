{ pkgs, ... }:
{
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
}
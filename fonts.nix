{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # --- Fonts ---
  fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
    # Polices universelles (inclut le coréen)
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  
    # Polices coréennes spécifiques et populaires
    nanum
    baekmuk-ttf
  ];
}
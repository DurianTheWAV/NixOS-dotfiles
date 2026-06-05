{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # --- Fonts ---
  fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
    # Universal fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}

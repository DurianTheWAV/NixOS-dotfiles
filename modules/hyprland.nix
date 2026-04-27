{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprland
    waybar
    swaylock
    swappy
    wl-clipboard
  ];

  # OPTIONAL: if you want hyprland session for a display manager (SDDM/LightDM),
  # add .desktop session files or configure your DM accordingly.
}

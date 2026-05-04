{config, pkgs, unstable,zen-browser, ...}:

 let
    system = pkgs.stdenv.hostPlatform.system;
 in
{
 environment.systemPackages = with pkgs; [
    zen-browser.packages.${system}.default
  ];
}

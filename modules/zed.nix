{ pkgs, inputs, ...}:

{ 
  environment.systemPackages = [
    inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

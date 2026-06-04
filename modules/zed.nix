{ pkgs, inputs, ...}:

{ 
  environment.systemPackages = with pkgs; [
    inputs.zed.packages.${system}.default
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./home.nix
    ./hyprland.nix
    ./machine.nix
    ./xdg.nix
  ];
}

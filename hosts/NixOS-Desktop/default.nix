{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./xserver.nix

    ./spectacle.nix
  ];

  environment.systemPackages =
    with pkgs;
    with kdePackages;
    [
      spectacle
    ];
}

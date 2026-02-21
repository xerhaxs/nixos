{
  config,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  environment.systemPackages = [
    pkgs.kdePackages.frameworkintegration
  ];

  services.fprintd.enable = true;
}

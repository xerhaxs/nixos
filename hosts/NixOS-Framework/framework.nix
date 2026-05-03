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

  environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
    directories = [
      "/var/lib/fprint"
    ];
  };
}

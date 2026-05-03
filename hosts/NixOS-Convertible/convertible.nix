{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.fprintd.enable = true;

  environment.persistence."/persistent" = lib.mkIf config.nixos.disko-luks-btrfs-tmpfs.enable {
    directories = [
      "/var/lib/fprint"
    ];
  };
}

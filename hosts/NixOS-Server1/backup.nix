{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.system.restic = {
    enable = false;
    time = "02:00";
    zfsDatasets = [
      "pool01/applications"
      "pool01/shares"
      "pool01/shares/jf"
    ];
    exclude = [
      "/pool01/shares/.zfs/snapshot/restic-proton/video"
      ".recycle"
      ".Trash-*"
    ];
    repositories.proton = {
      repository = "rclone:proton:nixos-server1";
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigSecret = config.sops.secrets."restic/rclone-proton".path;
    };
  };

  sops.secrets = lib.mkIf config.nixos.system.restic.enable {
    "restic/password" = { };
    "restic/rclone-proton" = { };
  };
}

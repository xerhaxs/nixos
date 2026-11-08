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
    # Only irreplaceable data fits into the 2 TB of Proton Drive (decision 08.11.2026). Every dataset
    # is snapshotted on its own, child datasets of pool01/shares have to be listed separately.
    zfsDatasets = [
      "pool01/shares/document"
      "pool01/shares/jf"
      "pool01/shares/photo"
    ];
    zfsSubdirs = {
      "pool01/shares/document" = [
        "Office Dokumente"
        "Wiso Mein Geld"
      ];
      "pool01/shares/jf" = [ "Dokumente" ];
    };
    exclude = [
      ".recycle"
      ".Trash-*"
    ];
    repositories.proton = {
      repository = "rclone:proton:nixos-server1";
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigSecret = config.sops.secrets."restic/rclone-proton".path;
      # Proton Duo has 2 TB.
      sizeLimit = 1900000000000;
    };
  };

  sops.secrets = lib.mkIf config.nixos.system.restic.enable {
    "restic/password" = { };
    "restic/rclone-proton" = { };
  };
}

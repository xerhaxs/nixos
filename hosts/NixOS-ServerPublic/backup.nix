{
  config,
  lib,
  pkgs,
  ...
}:

# Nightly dumps of all databases (Matrix, Miniflux) for the backup in the Contabo portal.
{
  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    compression = "zstd";
    location = "/var/backup/postgresql";
    startAt = "02:30";
  };

  environment.persistence."/persistent".directories = [ "/var/backup" ];
}

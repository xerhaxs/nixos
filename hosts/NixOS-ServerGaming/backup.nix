{
  config,
  lib,
  pkgs,
  ...
}:

let
  storagebox = config.nixos.site.serverGaming.storageBox;
in

{
  sops.secrets = {
    "restic/password" = { };
    "restic/home-env" = { };
    "restic/storagebox-ssh-key" = { };
  };

  nixos.system.restic = {
    enable = true;
    repositories = {
      home = {
        repository = "rest:http://10.100.0.2:8000/nixos-servergaming/";
        passwordFile = config.sops.secrets."restic/password".path;
        environmentFile = config.sops.secrets."restic/home-env".path;
      };
      storagebox = {
        repository = "sftp:${lib.head (lib.splitString "." storagebox)}@${storagebox}:/home/restic/nixos-servergaming";
        passwordFile = config.sops.secrets."restic/password".path;
        extraOptions = [
          "sftp.command='ssh ${lib.head (lib.splitString "." storagebox)}@${storagebox} -p 23 -i ${
            config.sops.secrets."restic/storagebox-ssh-key".path
          } -o StrictHostKeyChecking=accept-new -s sftp'"
        ];
      };
    };
  };
}

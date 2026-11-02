{
  config,
  lib,
  pkgs,
  ...
}:

{
  sops.secrets = {
    "restic/password" = { };
    "restic/home-env" = { };
  };

  nixos.system.restic = {
    enable = true;
    repositories = {
      home = {
        repository = "rest:http://10.100.0.2:8000/nixos-serverpublic/";
        passwordFile = config.sops.secrets."restic/password".path;
        environmentFile = config.sops.secrets."restic/home-env".path;
      };
    };
  };
}

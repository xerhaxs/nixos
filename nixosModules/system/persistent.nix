{
  config,
  lib,
  pkgs,
  impermanence,
  ...
}:

{
  options.nixos = {
    system.persistent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable persistent.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.persistent.enable {
    environment.persistence."/persistent" = {
      enable = true;
      hideMounts = true;
      allowTrash = true;

      directories = [
        "/root/.cache"
        "/var/log"
        "/var/cache"
        #{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      ];
      #files = [
      #  "/etc/machine-id"
      #  { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      #];
    };
  };
}

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
        {
          directory = "/var/lib/private";
          mode = "0700";
        }
        #{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      ]
      ++
        lib.optionals
          (config.services.postgresql.enable && lib.hasPrefix "/var/lib/" config.services.postgresql.dataDir)
          [
            {
              directory = "/var/lib/postgresql";
              user = "postgres";
              group = "postgres";
              mode = "0750";
            }
          ];
      # A new machine-id on every boot splits the journal (journalctl only shows the current boot).
      files = [
        "/etc/machine-id"
      ];
    };
  };
}

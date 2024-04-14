{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.searxng = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Searxng.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.searxng.enable {
    systemd.services.searx-init.serviceConfig.EnvironmentFile = [ 
      config.sops.secrets."searxng/secret".path
    ];

    services.searx = {
      enable = true;
      redisCreateLocally = false;
      runInUwsgi = false;
      settingsFile = config/searxng.yml;
      environmentFile = config.sops.secrets."searxng/secret".path;
      settings = {
        server.port = 8888;
        server.bind_address = "0.0.0.0";
        server.secret_key = "@SEARX_SECRET_KEY@";
      };
    };
  };
}

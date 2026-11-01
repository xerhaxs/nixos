{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.tools.searxng = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Searxng.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.tools.searxng.enable {
    sops.secrets."searxng/secret" = { };

    systemd.services.searx-init.serviceConfig.EnvironmentFile = [
      config.sops.secrets."searxng/secret".path
    ];

    services.searx = {
      enable = true;
      redisCreateLocally = false;
      configureUwsgi = false;
      settingsPath = "${pkgs.substitute {
        src = ./config/searxng.yml;
        substitutions = [
          "--replace-fail"
          "@domain@"
          config.nixos.server.network.nginx.domain
        ];
      }}";
      environmentFile = config.sops.secrets."searxng/secret".path;
      settings = {
        server.port = 8888;
        server.bind_address = "127.0.0.1";
        server.secret_key = "$SEARX_SECRET_KEY";
      };
    };

    services.nginx = {
      virtualHosts = {
        "searxng.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8888";
          };
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.fediverse.libretranslate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable libretranslate server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.libretranslate.enable {
    services.libretranslate = {
      enable = true;
      host = "127.0.0.1";
      port = 5005;
      user = "libretranslate";
      group = "libretranslate";
      domain = "libretranslate.${config.nixos.server.network.nginx.domain}";
      dataDir = "/var/lib/libretranslate";
      disableWebUI = false;
      updateModels = true;
      enableApiKeys = true;
      configureNginx = false;
      extraArgs = {
        debug = false;
        disable-files-translation = false;
        metrics = true;
        translation-cache = "all";
      };
    };

    services.nginx = {
      virtualHosts = {
        "libretranslate.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:5005";
          };
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.tools.languagetool = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable languagetool.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.tools.languagetool.enable {
    services.languagetool = {
      enable = true;
      port = 8001;
      public = false;
      settings = {
        cacheSize = 1000;
      };
      jvmOptions = [
        "-Xmx512m"
      ];
    };

    services.nginx = {
      virtualHosts = {
        "languagetool.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8001";
            # Host and X-Forwarded-* come from recommendedProxySettings. Setting Host again sends it
            # twice, LanguageTool then answers every request with 400 "Multiple Host headers".
            extraConfig = ''
              proxy_set_header Content-Type "application/x-www-form-urlencoded";
            '';
          };
        };
      };
    };
  };
}

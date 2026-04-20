{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.public.cryptpad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable cryptpad.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.cryptpad.enable { # https://docs.cryptpad.org/en/admin_guide/installation.html + https://github.com/cryptpad/cryptpad/blob/main/config/config.example.js
    services.cryptpad = {
      enable = true;
      settings = {
        httpAddress = "127.0.0.1";
        httpPort = 3666;
        websocketPort = 3667;
        httpUnsafeOrigin = "cryptpad.${config.nixos.server.network.nginx.domain}";
        httpSafeOrigin = "cryptpad-sandbox.${config.nixos.server.network.nginx.domain}";
        blockDailyCheck = true;
        installMethod = "nixos";
        #adminKeys = [
        #  "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]"
        #]
        logLevel = "info";
        logToStdout = true;

        
        otpSessionExpiration = 7;
        enforceMFA = true;
        logIP = false;

        inactiveTime = 90;
        archiveRetentionTime = 14;
        accountRetentionTime = 365;
        maxUploadSize = 100 * 1024; # 100 MB
      };
    };

    services.nginx = {
      virtualHosts = {
        "cryptpad.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090/";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}

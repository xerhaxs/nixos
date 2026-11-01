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

      adminKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]" ];
        description = "Public signing keys of the CryptPad administrators.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.cryptpad.enable {
    services.cryptpad = {
      enable = true;
      configureNginx = true;
      settings = {
        httpAddress = "127.0.0.1";
        httpPort = 3666;
        websocketPort = 3667;
        httpUnsafeOrigin = "https://cryptpad.${config.nixos.server.network.nginx.domain}";
        httpSafeOrigin = "https://cryptpad-sandbox.${config.nixos.server.network.nginx.domain}";
        blockDailyCheck = true;
        installMethod = "nixos";
        adminKeys = config.nixos.server.public.cryptpad.adminKeys;
        logLevel = "info";
        logToStdout = true;

        otpSessionExpiration = 7;
        enforceMFA = true;
        logIP = false;

        inactiveTime = 90;
        archiveRetentionTime = 14;
        accountRetentionTime = 365;
        maxUploadSize = 100 * 1024 * 1024;
      };
    };

    services.nginx = {
      virtualHosts = {
        "cryptpad.${config.nixos.server.network.nginx.domain}" = {
          acmeRoot = null;
          kTLS = true;
          http2 = true;
        };
      };
    };

  };
}

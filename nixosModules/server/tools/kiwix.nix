{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.tools.kiwix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kiwix server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.tools.kiwix.enable {
    services.kiwix-serve = {
      enable = true;
      openFirewall = false;
      address = "127.0.0.1";
      port = 2793;
      libraryPath = "${config.nixos.server.dataDir}/kiwix/library.xml";
      extraArgs = [ ];
    };

    systemd.services.kiwix-serve.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "kiwix";
      Group = "kiwix";
    };

    environment.systemPackages = with pkgs; [
      kiwix-tools
    ];

    services.nginx = {
      virtualHosts = {
        "kiwix.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:2793";
          };
        };
      };
    };
  };
}

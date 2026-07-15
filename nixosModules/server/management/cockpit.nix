{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.management.cockpit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable cockpit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.management.cockpit.enable {
    services.cockpit = {
      enable = true;
      openFirewall = false;
      port = 9090;
      showBanner = true;
      allowed-origins = [
        "https://cockpit.${config.nixos.server.network.nginx.domain}"
      ];
      settings = { };
      plugins = with pkgs; [
        cockpit-zfs
        cockpit-files
        cockpit-podman
        cockpit-machines
      ];
    };

    services.nginx = {
      virtualHosts = {
        "cockpit.${config.nixos.server.network.nginx.domain}" = {
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

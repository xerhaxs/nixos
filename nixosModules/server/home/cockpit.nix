{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.cockpit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable cockpit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.cockpit.enable {
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

    boot.crashDump.enable = true;

    environment.systemPackages = with pkgs; [
      kexec-tools
    ];

    services.nginx = {
      virtualHosts = {
        "cockpit.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090/";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}

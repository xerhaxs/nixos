{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = "m4rx.cc";
in

{
  options.nixos = {
    server.network.nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Nginx.";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "${domain}";
        example = "example.com";
        description = "Domain for nginx.";
      };

      challenge = lib.mkOption {
        type = lib.types.enum [
          "dns-01"
          "http-01"
        ];
        default = "dns-01";
        example = "http-01";
        description = "Set the default ACME challenge.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.nginx.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      #virtualHosts = {
      #"${config.nixos.server.network.nginx.domain}" = {
      #  forceSSL = true;
      #  enableACME = true;
      #  acmeRoot = null;
      #  kTLS = true;
      #  http2 = true;
      #  http3 = true;
      #  quic = true;
      #  root = "/mount/Data/Datein/Server/startpage/index.html";
      #};
      #};
    };

    security.acme = lib.mkMerge [
      (lib.mkIf (config.nixos.server.network.nginx.challenge == "dns-01") {
        acceptTerms = true;
        defaults = {
          email = "among_clavicle129@slmail.me";
          #dnsResolver = "127.0.0.1"; # for usage behind mullvad vpn
          dnsProvider = "cloudflare";
          #dnsPropagationCheck = false; # for usage behind mullvad vpn
          extraLegoFlags = [
            "--dns.propagation-wait"
            "60s"
          ];
          renewInterval = "daily";
          environmentFile = config.sops.secrets."nginx/acme/api_key".path;
        };
      })
      (lib.mkIf (config.nixos.server.network.nginx.challenge == "http-01") {
        acceptTerms = true;
        defaults = {
          email = "among_clavicle129@slmail.me";
          renewInterval = "daily";
        };
      })
    ];

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/acme"
      ];
    };
  };
}

{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet.enable = true;

  networking.firewall.enable = lib.mkForce false; # only for testing purpos

  services.mullvad-vpn.enable = true;

  users.groups.truenas = {
    members = [
      "lidarr"
      "radarr"
      "sabnzbd"
      "sonarr"
      "nzbget"
    ];
  };

  environment.systemPackages = [
    pkgs.mullvad
  ];







  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "test.${config.nixos.server.network.nginx.domain}" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        kTLS = true;
        http2 = false;
        root = "/home/admin/index.html";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    preliminarySelfsigned = true;
    defaults = {
      dnsResolver = "1.1.1.1";
      email = "among_clavicle129@slmail.me";
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      renewInterval = "daily";
      environmentFile = config.sops.secrets."nginx/acme/api_key".path;
    };
  };
}
{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.ddclient = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ddclient.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.ddclient.enable {
    services.ddclient = {
      enable = true;
      zone = "${config.nixos.server.network.nginx.domain}";
      use = "web, web=ipify-ipv6";
      ssl = true;
      protocol = "cloudflare";
      passwordFile = config.sops.secrets."cloudflare/api_key".path;
    };
  };
}

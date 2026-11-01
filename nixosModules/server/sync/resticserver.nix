{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.sync.resticserver;
in

{
  options.nixos = {
    server.sync.resticserver = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable restic REST server.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "10.100.0.2";
        description = "Address the REST server listens on (WireGuard IP of this host).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        description = "Port of the REST server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."resticserver/htpasswd" = {
      owner = "restic";
      group = "restic";
      mode = "0400";
    };

    services.restic.server = {
      enable = true;
      listenAddress = "${cfg.listenAddress}:${toString cfg.port}";
      dataDir = "${config.nixos.server.dataDir}/restic";
      appendOnly = true;
      privateRepos = true;
      htpasswd-file = config.sops.secrets."resticserver/htpasswd".path;
    };

    systemd.services.restic-rest-server = lib.mkIf config.nixos.system.wireguard.enable {
      wants = [ "wireguard-${config.nixos.system.wireguard.interface}.service" ];
      after = [ "wireguard-${config.nixos.system.wireguard.interface}.service" ];
    };

    networking.firewall.interfaces.${config.nixos.system.wireguard.interface}.allowedTCPPorts = [
      cfg.port
    ];
  };
}

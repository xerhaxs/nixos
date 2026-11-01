{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.wireguard;
  hostName = config.networking.hostName;

  hub = "NixOS-ServerPublic";

  peers = {
    NixOS-ServerPublic = {
      ip = "10.100.0.1";
      publicKey = "sBh0DQlOJwzQnjulBnx5KYISw8wKqCdl6zF/R/8pj24=";
    };
    NixOS-Server1 = {
      ip = "10.100.0.2";
      publicKey = null;
    };
    NixOS-Desktop = {
      ip = "10.100.0.3";
      publicKey = null;
    };
    NixOS-Framework = {
      ip = "10.100.0.4";
      publicKey = null;
    };
    NixOS-Convertible = {
      ip = "10.100.0.5";
      publicKey = null;
    };
    NixOS-ServerGaming = {
      ip = "10.100.0.6";
      publicKey = null;
    };
    GrapheneOS = {
      ip = "10.100.0.10";
      publicKey = null;
    };
  };

  isHub = hostName == hub;
  validPeers = lib.filterAttrs (name: peer: peer.publicKey != null && name != hostName) peers;
in

{
  options.nixos = {
    system.wireguard = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the WireGuard network.";
      };

      interface = lib.mkOption {
        type = lib.types.str;
        default = "wg0";
        description = "Name of the WireGuard interface.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 51820;
        description = "Listen port of the hub.";
      };

      subnet = lib.mkOption {
        type = lib.types.str;
        default = "10.100.0.0/24";
        description = "WireGuard subnet, routed through the tunnel on the peers (split tunnel).";
      };

      hubAddress = lib.mkOption {
        type = lib.types.str;
        default = config.nixos.site.serverPublic.ipv4;
        defaultText = lib.literalExpression "config.nixos.site.serverPublic.ipv4";
        description = "Public IP of the hub (an IP, so the tunnel works without DNS and can bypass Mullvad).";
      };

      dns = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = if config.nixos.desktop.enable then "10.100.0.2" else null;
        defaultText = lib.literalExpression "Pi-hole on NixOS-Server1 for desktops";
        description = "DNS server used for all domains while the tunnel is up (Pi-hole on NixOS-Server1).";
      };

      hasPeers = lib.mkOption {
        type = lib.types.bool;
        readOnly = true;
        default = validPeers != { };
        description = "Whether peers with public keys exist for this host.";
      };

      enrolled = lib.mkOption {
        type = lib.types.bool;
        readOnly = true;
        default = (peers.${hostName} or { publicKey = null; }).publicKey != null;
        description = "Whether this host has a public key in the peer list, so the hub accepts it.";
      };

      mullvadBypass = lib.mkOption {
        type = lib.types.bool;
        default = config.services.mullvad-vpn.enable;
        description = "Let traffic to the hub bypass Mullvad (needed with Mullvad lockdown mode).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = peers ? ${hostName};
        message = "nixos.system.wireguard: ${hostName} is missing in the peer list of nixosModules/system/wireguard.nix.";
      }
    ];

    sops.secrets."wireguard/${lib.toLower hostName}/private" = { };

    networking.wireguard.interfaces.${cfg.interface} = {
      ips = [ "${peers.${hostName}.ip}/24" ];
      listenPort = lib.mkIf isHub cfg.port;
      privateKeyFile = config.sops.secrets."wireguard/${lib.toLower hostName}/private".path;

      postSetup = lib.mkIf (!isHub && cfg.dns != null) ''
        ${config.systemd.package}/bin/resolvectl dns ${cfg.interface} ${cfg.dns}
        ${config.systemd.package}/bin/resolvectl domain ${cfg.interface} "~."
        ${config.systemd.package}/bin/resolvectl dnsovertls ${cfg.interface} no
        ${config.systemd.package}/bin/resolvectl default-route ${cfg.interface} true
      '';

      peers =
        if isHub then
          lib.mapAttrsToList (name: peer: {
            inherit name;
            publicKey = peer.publicKey;
            allowedIPs = [ "${peer.ip}/32" ];
          }) validPeers
        else
          [
            {
              name = hub;
              publicKey = peers.${hub}.publicKey;
              allowedIPs = [ cfg.subnet ];
              endpoint = "${cfg.hubAddress}:${toString cfg.port}";
              persistentKeepalive = 25;
            }
          ];
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkIf isHub 1;

    networking.firewall.allowedUDPPorts = lib.mkIf isHub [ cfg.port ];

    networking.networkmanager.unmanaged = lib.mkIf config.networking.networkmanager.enable [
      cfg.interface
    ];

    systemd.services.wireguard-mullvad-bypass = lib.mkIf cfg.mullvadBypass {
      description = "Exclude WireGuard hub traffic from Mullvad";
      wantedBy = [ "multi-user.target" ];
      before = [ "wireguard-${cfg.interface}.service" ];
      after = [ "mullvad-daemon.service" ];
      serviceConfig = config.nixos.system.hardening.unitHardening // {
        Type = "oneshot";
        RemainAfterExit = true;
        ProtectSystem = "strict";
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
        ExecStart = "${pkgs.nftables}/bin/nft -f ${pkgs.writeText "wg-mullvad-bypass.nft" ''
          table inet wgMullvadBypass {
            chain excludeOutgoing {
              type route hook output priority 0; policy accept;
              ip daddr ${cfg.hubAddress} udp dport ${toString cfg.port} ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            }
          }
        ''}";
        ExecStop = "${pkgs.nftables}/bin/nft delete table inet wgMullvadBypass";
      };
    };
  };
}

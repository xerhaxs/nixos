{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.tools.moneronode;
  lanSubnet = config.nixos.system.networking.lan.subnet;
  wgInterface = config.nixos.system.wireguard.interface;
in

{
  options.nixos = {
    server.tools.moneronode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable a pruned Monero node.";
      };

      restrictedRpcPort = lib.mkOption {
        type = lib.types.port;
        default = 18089;
        description = "Port of the restricted RPC for wallets in the LAN and the WireGuard network.";
      };

      p2pool = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Enable P2Pool (mini sidechain) for miners in the LAN (secret monero/p2pool-env with WALLET_ADDRESS).";
        };

        stratumPort = lib.mkOption {
          type = lib.types.port;
          default = 3333;
          description = "Stratum port miners (xmrig) connect to.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.monero = {
          enable = true;
          dataDir = "${config.nixos.server.dataDir}/monero";
          prune = true;

          rpc = {
            address = "127.0.0.1";
            port = 18081;
            restricted = false;
          };

          mining.enable = false;

          limits = {
            upload = 1000;
            download = 8000;
            threads = 2;
          };

          extraConfig = ''
            rpc-restricted-bind-ip=0.0.0.0
            rpc-restricted-bind-port=${toString cfg.restrictedRpcPort}
            confirm-external-bind=1
            zmq-pub=tcp://127.0.0.1:18083
            no-igd=1
            out-peers=32
            db-sync-mode=safe
          '';
        };

        # The modules only create their data dirs as the home of the user, at activation. On a
        # dataset that is mounted later (encrypted ZFS), tmpfiles has to create them again.
        systemd.tmpfiles.rules = [
          "d ${config.services.monero.dataDir} 0750 monero monero -"
        ]
        ++ lib.optional cfg.p2pool.enable "d ${config.services.p2pool.dataDir} 0750 p2pool p2pool -";

        networking.firewall = {
          extraCommands = ''
            iptables -A nixos-fw -p tcp -s ${lanSubnet} --dport ${toString cfg.restrictedRpcPort} -j nixos-fw-accept
          ''
          + lib.optionalString cfg.p2pool.enable ''
            iptables -A nixos-fw -p tcp -s ${lanSubnet} --dport ${toString cfg.p2pool.stratumPort} -j nixos-fw-accept
          '';
          interfaces.${wgInterface}.allowedTCPPorts = lib.mkIf config.nixos.system.wireguard.enable (
            [ cfg.restrictedRpcPort ] ++ lib.optional cfg.p2pool.enable cfg.p2pool.stratumPort
          );
        };
      }

      (lib.mkIf cfg.p2pool.enable {
        sops.secrets."monero/p2pool-env" = { };

        services.p2pool = {
          enable = true;
          sidechain = "mini";
          host = "127.0.0.1";
          rpcPort = 18081;
          zmqPort = 18083;
          walletAddress = "$WALLET_ADDRESS";
          environmentFile = config.sops.secrets."monero/p2pool-env".path;
          dataDir = "${config.nixos.server.dataDir}/p2pool";
          extraArgs = [
            "--stratum 0.0.0.0:${toString cfg.p2pool.stratumPort}"
            "--no-upnp"
          ];
        };

        systemd.services.p2pool = {
          after = [ "monero.service" ];
          wants = [ "monero.service" ];
        };
      })
    ]
  );
}

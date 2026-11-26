{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.public.mediamtx;
  hostname = "stream.${config.nixos.server.network.nginx.domain}";
  hlsPort = 8888;
  playbackPort = 9996;
  srtPort = 8890;
in

{
  options.nixos = {
    server.public.mediamtx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable MediaMTX for an emergency stream from the phone: SRT ingest with login and passphrase, every stream recorded until deleted by hand, live view and recordings behind nginx with login (secret mediamtx/env).";
      };

      path = lib.mkOption {
        type = lib.types.str;
        default = "notfall";
        description = "Stream path, part of the SRT streamid and the URLs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # MTX_AUTHINTERNALUSERS_0_PASS (publisher), MTX_AUTHINTERNALUSERS_1_PASS (viewer),
    # MTX_PATHS_<PATH>_SRTPUBLISHPASSPHRASE, MTX_PATHS_<PATH>_SRTREADPASSPHRASE (10 to 79 characters).
    sops.secrets."mediamtx/env".restartUnits = [ "mediamtx.service" ];

    services.mediamtx = {
      enable = true;
      settings = {
        logLevel = "info";
        logDestinations = [ "stdout" ];

        # The passwords come from the environment, the unit does not start without the secret.
        authMethod = "internal";
        authInternalUsers = [
          {
            user = "publisher";
            pass = "";
            ips = [ ];
            permissions = [
              {
                action = "publish";
                inherit (cfg) path;
              }
            ];
          }
          {
            user = "jf";
            pass = "";
            ips = [ ];
            permissions = [
              {
                action = "read";
                inherit (cfg) path;
              }
              {
                action = "playback";
                inherit (cfg) path;
              }
            ];
          }
        ];

        api = false;
        metrics = false;
        moq = false;
        pprof = false;
        rtsp = false;
        rtmp = false;
        webrtc = false;

        srt = true;
        srtAddress = ":${toString srtPort}";

        hls = true;
        hlsAddress = "127.0.0.1:${toString hlsPort}";
        hlsTrustedProxies = [ "127.0.0.1" ];

        playback = true;
        playbackAddress = "127.0.0.1:${toString playbackPort}";
        playbackTrustedProxies = [ "127.0.0.1" ];

        pathDefaults.record = false;
        paths.${cfg.path} = {
          # Written every second, an interrupted file stays playable. One file per stream (up to a
          # day), never deleted automatically.
          record = true;
          recordPath = "/var/lib/mediamtx/recordings/%path/%Y-%m-%d_%H-%M-%S-%f";
          recordFormat = "fmp4";
          recordPartDuration = "1s";
          recordSegmentDuration = "24h";
          recordDeleteAfter = "0s";
        };
      };
    };

    systemd.services.mediamtx.serviceConfig = config.nixos.system.hardening.unitHardening // {
      EnvironmentFile = config.sops.secrets."mediamtx/env".path;
      # Below /var/lib/private, which the persistence keeps.
      StateDirectory = "mediamtx";
      StateDirectoryMode = "0700";
      CapabilityBoundingSet = "";
      PrivateDevices = true;
      ProcSubset = "pid";
      ProtectHostname = true;
      ProtectProc = "invisible";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
    };

    networking.firewall.allowedUDPPorts = [ srtPort ];

    services.nginx.virtualHosts.${hostname} = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;
      kTLS = true;
      http2 = true;
      # Live view (https://stream.<domain>/<path>/) and the playback server (/list, /get), both ask
      # for the login of MediaMTX themselves.
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString hlsPort}";
          extraConfig = ''
            proxy_buffering off;
          '';
        };
        "= /list".proxyPass = "http://127.0.0.1:${toString playbackPort}";
        "= /get" = {
          proxyPass = "http://127.0.0.1:${toString playbackPort}";
          extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 1h;
          '';
        };
      };
    };
  };
}

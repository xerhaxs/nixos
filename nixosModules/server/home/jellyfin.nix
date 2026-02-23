{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.jellyfin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Jellyfin.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = false;
      user = "jellyfin";
      group = "jellyfin";
      dataDir = "/pool01/applications/jellyfin";
      #dataDir = "/var/lib/jellyfin";
      #configDir = "/var/lib/jellyfin/config";
      #logDir = "/var/log/jellyfin";
      #cacheDir = "/var/cache/jellyfin";
      forceEncodingConfig = false;
      hardwareAcceleration = {
        enable = true;
        device = "/dev/dri/renderD128";
        type = "qsv"; # "none", "amf", "qsv", "nvenc", "v4l2m2m", "vaapi", "rkmpp"
      };

      transcoding = {
        encodingPreset = "auto";
        throttleTranscoding = false;
        threadCount = 4;
        maxConcurrentStreams = 0;
        enableToneMapping = true;
        enableSubtitleExtraction = true;
        enableIntelLowPowerEncoding = false;
        deleteSegments = true;

        enableHardwareEncoding = true;
        hardwareEncodingCodecs = {
          hevc = true;
          av1 = true;
        };

        hardwareDecodingCodecs = {
          vp9 = true;
          vp8 = true;
          vc1 = true;
          mpeg2 = true;
          hevcRExt12bit = true;
          hevcRExt10bit = true;
          hevc10bit = true;
          hevc = true;
          h264 = true;
          av1 = true;
        };

        h265Crf = 28;
        h264Crf = 23;
      };
    };

    users.users.jellyfin.extraGroups = [
      "share"
      "render"
      "video"
    ];

    environment.systemPackages = with pkgs; [
      libva-utils
    ];

    services.nginx = {
      virtualHosts = {
        "jellyfin.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8096";
          };
        };
      };
    };
  };
}

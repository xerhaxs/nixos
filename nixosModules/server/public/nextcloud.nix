{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = config.nixos.server.network.nginx.domain;
  hostname = "cloud.${domain}";
  officeHostname = "office.${domain}";
  occ = "${config.services.nextcloud.occ}/bin/nextcloud-occ";
in

{
  options.nixos = {
    server.public.nextcloud = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Nextcloud.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.nextcloud.enable {
    sops.secrets."nextcloud/admin" = {
      owner = "nextcloud";
      group = "nextcloud";
      mode = "0400";
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud35;
      hostName = hostname;
      https = true;
      home = "${config.nixos.server.dataDir}/nextcloud";
      maxUploadSize = "16G";

      database.createLocally = true;
      configureRedis = true;

      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = config.sops.secrets."nextcloud/admin".path;
      };

      appstoreEnable = false;
      autoUpdateApps.enable = false;
      extraAppsEnable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          calendar
          contacts
          dav_push
          end_to_end_encryption
          richdocuments
          spreed
          ;
      };

      notify_push = {
        enable = true;
        bendDomainToLocalhost = true;
      };

      settings = {
        default_phone_region = "DE";
        maintenance_window_start = 1;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        overwriteprotocol = "https";
        log_type = "file";
        loglevel = 2;
        "simpleSignUpLink.shown" = false;
      };

      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "256";
      };
    };

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
        };
      };
    };

    networking.hosts = {
      "127.0.0.1" = [
        hostname
        officeHostname
      ];
      "::1" = [
        hostname
        officeHostname
      ];
    };

    systemd.services.nextcloud-apps-setup = {
      description = "Configure Nextcloud Office and Talk";
      after = [
        "nextcloud-setup.service"
        "coolwsd.service"
      ];
      requires = [ "nextcloud-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = config.nixos.system.hardening.unitHardening // {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "nextcloud";
        LoadCredential = lib.optional config.nixos.server.public.coturn.enable "turn-secret:${
          config.sops.secrets."coturn/secret".path
        }";
      };
      script = ''
        ${occ} config:app:set files default_quota --value="5 GB"
        ${lib.optionalString config.nixos.server.public.collabora.enable ''
          ${occ} config:app:set richdocuments wopi_url --value="https://${officeHostname}"
          ${occ} config:app:set richdocuments public_wopi_url --value="https://${officeHostname}"
          ${occ} config:app:set richdocuments wopi_allowlist --value="127.0.0.1,::1"
          ${occ} richdocuments:activate-config || true
        ''}
        ${lib.optionalString config.nixos.server.public.coturn.enable ''
          secret="$(cat "$CREDENTIALS_DIRECTORY/turn-secret")"
          ${occ} config:app:set spreed stun_servers --value='["turn.${domain}:3478"]'
          ${occ} config:app:set spreed turn_servers --value="[{\"schemes\":\"turn,turns\",\"server\":\"turn.${domain}:3478\",\"secret\":\"$secret\",\"protocols\":\"udp,tcp\"}]" > /dev/null
        ''}
      '';
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories =
        lib.optional (lib.hasPrefix "/var/lib/" config.services.nextcloud.home) {
          directory = config.services.nextcloud.home;
          user = "nextcloud";
          group = "nextcloud";
          mode = "0750";
        }
        ++ [
          {
            directory = "/var/lib/redis-nextcloud";
            user = "nextcloud";
            group = "nextcloud";
            mode = "0700";
          }
        ];
    };
  };
}

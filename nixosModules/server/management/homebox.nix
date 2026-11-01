{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.management.homebox;
  dataDir = "${config.nixos.server.dataDir}/homebox";
  port = 7745;
in

{
  options.nixos = {
    server.management.homebox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable HomeBox inventory management.";
      };

      allowRegistration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Allow new accounts (enable once to create the accounts).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.homebox = {
      enable = true;
      settings = {
        HBOX_WEB_HOST = "127.0.0.1";
        HBOX_WEB_PORT = toString port;
        HBOX_OPTIONS_ALLOW_REGISTRATION = lib.boolToString cfg.allowRegistration;
        HBOX_OPTIONS_TRUST_PROXY = "true";
      };
    };

    systemd.tmpfiles.rules = lib.mkIf (dataDir != "/var/lib/homebox") [
      "d ${dataDir} 0750 ${config.services.homebox.user} ${config.services.homebox.group} -"
    ];

    systemd.services.homebox.serviceConfig.BindPaths = lib.mkIf (dataDir != "/var/lib/homebox") [
      "${dataDir}:/var/lib/homebox"
    ];

    services.nginx = {
      virtualHosts = {
        "homebox.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          extraConfig = ''
            client_max_body_size 50M;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        };
      };
    };

    environment.persistence."/persistent" =
      lib.mkIf (config.nixos.disko.disko-luks-btrfs-tmpfs.enable && dataDir == "/var/lib/homebox")
        {
          directories = [
            {
              directory = "/var/lib/homebox";
              user = config.services.homebox.user;
              group = config.services.homebox.group;
              mode = "0750";
            }
          ];
        };
  };
}

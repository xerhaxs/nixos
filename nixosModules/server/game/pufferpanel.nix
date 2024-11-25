{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.game.pufferpanel = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Pufferpanel.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.game.pufferpanel.enable {
    systemd.services.pufferpanel.serviceConfig.EnvironmentFile = [ 
      config.sops.secrets."pufferpanel/users/admin/email".path
      config.sops.secrets."pufferpanel/users/admin/password".path 
    ];

    environment.systemPackages = with pkgs; [
      pufferpanel
    ];

    # setup admin account: "pufferpanel user add" 

    services.pufferpanel = {
      enable = true;
      
      environment = {
        PUFFER_WEB_HOST = ":9090";
        PUFFER_DAEMON_SFTP_HOST = ":5657";
        PUFFER_DAEMON_CONSOLE_BUFFER = "1000";
        PUFFER_DAEMON_CONSOLE_FORWARD = "true";
        PUFFER_PANEL_REGISTRATIONENABLED = "false";
        EMAILUSERNAME = "{env}ENV_EMAIL";
        EMAILPASSWORD = "{env}ENV_PASSWORD";
      };

      extraPackages = with pkgs; [
        jre
      ];
    };

    services.nginx = {
      virtualHosts = {
        "pufferpanel.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9090";
          };
        };

        "pufferpanel-sftp.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5657";
          };
        };
      };
    };

    services.ddclient.domains = [
      "pufferpanel.${config.nixos.server.network.nginx.domain}"
      "pufferpanel-sftp.${config.nixos.server.network.nginx.domain}"
    ];
  };
}

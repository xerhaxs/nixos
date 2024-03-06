{ config, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;
    openFirewall = false;
    allowDHCP = false;
    mutableSettings = true;
    settings = {
      bind_port = 3333;
      bind_host = "0.0.0.0";

      users = {
        name = "admin";
        password = "$2b$05$SQtHP4cmWpSeC9Zyz8K1q.ntk2glUlqvBUy3vj.X8LWEv9mHEhHJO";
      };
      
      dns = {
        bind_hosts = [ "127.0.0.1" "10.75.0.1" ];
        port = 3366;
        anonymize_client_ip = false;
        enable_dnssec = false;
        aaaa_disabled = true;
        theme = "dark";
      };

      tls = {
        enable = true;
        server_name = "adguard.bitsync.icu";
        force_https = true;
        port_https = 3333;
      };

      filtering = {
        protection_enabled = true;
        blocking_mode = "nxdomain";
      };

      statistics = {
        enabled = true;
        interval = "8760h";
      };

    #  filters = {
    #    enabled = true;
    #};
    #  schema_version = 20;
    };
  };
}

{ config, pkgs,... }:

{
  services.dnsmasq = {
    enable = true;
    settings = {
      domain-needed = true;
      cache-size = 10000;
      log-queries = true;
      log-facility = "/tmp/ad-block.log";
      local-ttl = 300;
      conf-file = "dns/blocklist.txt";
      addn-hosts = "dns/hostnames.txt";

      server = [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
        "9.9.9.10"
        "149.112.112.10"
        "2620:fe::10"
        "2620:fe::fe:10"
      ];
      #dhcp-range = [ "10.0.0.1,10.0.0.255" ];
    };
  };
}

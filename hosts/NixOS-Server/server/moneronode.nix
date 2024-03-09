{ config, pkgs, ... }:

{
  services.monero = {
    enable = true;
    #dataDir = "/var/lib/moneronode";

    rpc = {
      user = "admin";
      password = "CHANGEME";
      restricted = false;
      address = "monero.bitsync.icu";
      port = 18081;
    };

    mining = {
      enable = true;
      address = "8ABTHBP7Cbu3X3h7UTLH7Ubk2ELnL4KHr4CzXHVh8WGwjLV92P6sjGQPtKGbRwAaocegiyC8RWzb2BnAAY2n7BcsRSujdvp";
      threads = 2;
    };

    limits = {
      upload = 1000;
      download = 8000;
      threads = 2;
    };
  };
}

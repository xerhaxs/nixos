{ config, lib, pkgs, ... }:

{
  services.clamav = {
    daemon = {
      enable = true;
      #settings = {};
    };

    updater = {
      enable = true;
      interval = "hourly";
      frequency = 12;
      #settings = {};
    };

    scanner = {
      enable = true;
      interval = "*-*-* 04:00:00";
      scanDirectories = [
        "/home"
        "/var/lib"
        "/tmp"
        "/etc"
        "/var/tmp"
      ];
    };
  };
}

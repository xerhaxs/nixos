{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.clamav = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable ClamAV virus scanner.";
      };
    };
  };

  config = mkIf config.nixos.system.clamav.enable {
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
  };  
}

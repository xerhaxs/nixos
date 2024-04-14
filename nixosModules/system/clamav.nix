{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.clamav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ClamAV virus scanner.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.clamav.enable {
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

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.clamav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ClamAV virus scanner.";
      };

      extraScanDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "/mount/Data" ];
        description = "Additional directories of the daily scan (user data, shares, uploads).";
      };

      excludePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "^/pool01/shares/video" ];
        description = "Regular expressions of paths that are not scanned (ExcludePath).";
      };
    };
  };

  config = lib.mkIf config.nixos.system.clamav.enable {
    services.clamav = {
      daemon = {
        enable = true;
        settings = {
          ExcludePath = [
            "^/proc/"
            "^/sys/"
            "/\\.zfs/"
            "/\\.snapshots/"
          ]
          ++ config.nixos.system.clamav.excludePaths;
        };
      };

      updater = {
        enable = true;
        interval = "hourly";
        frequency = 12;
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
        ]
        ++ config.nixos.system.clamav.extraScanDirectories;
      };
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/clamav"
      ];
    };
  };
}

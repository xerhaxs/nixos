{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.io.bluetooth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bluetooth support.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.io.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      hsphfpd.enable = false;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/bluetooth"
      ];
    };
  };
}

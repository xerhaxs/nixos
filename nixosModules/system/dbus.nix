{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.dbus = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable dbus.";
      };
    };
  };

  config = mkIf config.nixos.system.dbus.enable {
    services.dbus = {
      enable = true;
    };
  };
}

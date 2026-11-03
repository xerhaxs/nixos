{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.dbus = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dbus.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.dbus.enable {
    # Each service file is found twice, in system-path and in its package. These messages are
    # harmless, but they fill journalctl -p err and hide real errors.
    systemd.services.dbus-broker = lib.mkIf (config.services.dbus.implementation == "broker") {
      serviceConfig.LogFilterPatterns = "~Ignoring duplicate name";
    };

    services.dbus = {
      enable = true;
    };
  };
}

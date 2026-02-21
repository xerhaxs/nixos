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
    services.dbus = {
      enable = true;
    };
  };
}

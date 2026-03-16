{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.smartd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable smartd.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.smartd.enable {
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        test = true;
        wall.enable = true;
        systembus-notify.enable = true;
      };
    };
  };
}

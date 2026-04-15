{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.communication.protonmail-bridge = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Protonmail bridge.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.protonmail-bridge.enable {
    services.protonmail-bridge = {
      enable = true;
      logLevel = "info";
      package = protonmail-bridge;
    };
  };
}

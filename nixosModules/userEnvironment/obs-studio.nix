{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.obs-studio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable obs-studio virtual camera module.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.obs-studio.enable {
    programs.obs-studio.enableVirtualCamera = true;
  };
}

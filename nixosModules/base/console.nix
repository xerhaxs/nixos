{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.console = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable console.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.console.enable {
    console = {
      enable = true;
    };
  };
}

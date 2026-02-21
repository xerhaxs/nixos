{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.shell.console = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable console.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.shell.console.enable {
    console = {
      enable = true;
    };
  };
}

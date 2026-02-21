{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.tools.usbtop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable usbtop.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.usbtop.enable {
    programs.usbtop = {
      enable = true;
    };
  };
}

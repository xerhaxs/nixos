{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.tools.java = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable java.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.java.enable {
    programs.java = {
      enable = true;
      package = pkgs.jdk;
      binfmt = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.appimage = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable appimage.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.appimage.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}

{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.android = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable android.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.android.enable {
    programs.adb = {
      enable = true;
    };
  };
}
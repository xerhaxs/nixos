{ config, lib, pkgs, ... }:

{
  defaultuser = "jf";

  options = {
    defaultuser.set = lib.mkOption {
      type = lib.types.str;
      default = null;
      example = "USER1";
      description = lib.mdDoc "Set a global user name.";
    };
  };
}

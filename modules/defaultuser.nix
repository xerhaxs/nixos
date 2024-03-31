{ config, lib, pkgs, ... }:

{
  options = {
    defaultuser = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = lib.mdDoc "Set a global user name.";
    };
  };
}

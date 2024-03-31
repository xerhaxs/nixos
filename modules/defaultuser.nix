{ config, lib, pkgs, ... }:

{
  options = {
    defaultuser = lib.mkOption {
      type = lib.types.str;
      description = "Set a global user name.";
    };

    defaultuser.pass.hash = lib.mkOption {
      type = lib.types.str;
      description = "Set the pass for the default user as a hash.";
    };
  };
}

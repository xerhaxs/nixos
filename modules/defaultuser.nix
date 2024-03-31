{ lib, options, ... }:

{
  options = {
    defaultuser = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Set a global user name.";
      };
      pass = lib.mkOption {
        type = lib.types.str;
        description = "Set the pass for the default user as a hash.";
        #required = lib.mkOverride 1;
        #depends = [ "name" ];
      };
    };

    config = {
      defaultuser = {
        name = options.defaultuser.name;
        pass = options.defaultuser.pass;
      };
    };
  };
}

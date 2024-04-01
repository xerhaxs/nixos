{ lib, options, ... }:

with lib;

{
  options = {
    defaultuser = {
      name = mkOption {
        type = types.str;
        description = "Set a global user name.";
      };
      pass = mkOption {
        type = types.str;
        description = "Set the pass for the default user as a hash.";
        #required = mkOverride 1;
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

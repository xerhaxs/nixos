{
  config,
  lib,
  pkgs,
  osConfig,
  userName,
  ...
}:

{
  options.homeManager = {
    base.ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ssh.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.ssh.enable {
    /* programs.ssh = {

    }; */
  };
}

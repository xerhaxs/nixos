{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.nfs-client = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable nfs client.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.nfs-client.enable {

  };
}

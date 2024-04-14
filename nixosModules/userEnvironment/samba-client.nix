{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.samba-client = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable samba client.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.samba-client.enable {
    services.gvfs.enable = true;
  };
}
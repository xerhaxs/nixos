{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.nextcloud-client = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable nextcloud-client sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.nextcloud-client.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}

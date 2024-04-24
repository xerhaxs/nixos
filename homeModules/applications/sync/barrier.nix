{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.sync.barrier = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable barrier sync.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.sync.barrier.enable {
    services.barrier.client = {
      enable = true;
      enableCrypto = true;
      enableDragDrop = true;
    };
  };
}

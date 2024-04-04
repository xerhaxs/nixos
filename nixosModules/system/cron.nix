{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.cron = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable cron service.";
      };
    };
  };

  config = lib.mkIf config.nixos.folder.name.enable {
    services.cron = {
      enable = true;
    };
  };
}
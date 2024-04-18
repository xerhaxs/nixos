{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.cron = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable cron service.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.cron.enable {
    services.cron = {
      enable = true;
    };
  };
}
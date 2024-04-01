{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.cron = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable cron service.";
      };
    };
  };

  config = mkIf config.nixos.folder.name.enable {
    services.cron = {
      enable = true;
    };
  };
}
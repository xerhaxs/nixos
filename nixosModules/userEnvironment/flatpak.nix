{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment.flatpak = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable flatpak.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.flatpak.enable {
    services.flatpak = {
      enable = true;
    };

    services.accounts-daemon.enable = true;
  };
}

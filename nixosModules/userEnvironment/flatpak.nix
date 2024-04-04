{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.flatpak = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable flatpak.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.flatpak.enable {
    services.flatpak = {
      enable = true;
    };

    services.accounts-daemon.enable = true;
  };
}

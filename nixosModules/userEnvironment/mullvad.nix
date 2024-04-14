{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.mullvad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mullvad vpn.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.mullvad.enable {
    services.mullvad-vpn = {
      enable = true;
      enableExcludeWrapper = true;
    };
  };
}
{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.nzbhydra2 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable NZBHydra2.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.nzbhydra2.enable {
    services.nzbhydra2 = {
      enable = true;
      openFirewall = false;
    };
  };
}

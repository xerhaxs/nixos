{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.readarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Readarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.readarr.enable {
    services.readarr = {
      enable = true;
      openFirewall = false;
      #dataDir = "";
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable server modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.server.enable {
    imports = [
      ./fediverse
      ./fileshare
      ./home
      ./network
      ./usenet
    ];
  };
}

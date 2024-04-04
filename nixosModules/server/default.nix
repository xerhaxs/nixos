{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable server modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.enable {
    imports = [
      ./fediverse
      ./fileshare
      ./home
      ./network
      ./usenet
    ];
  };
}

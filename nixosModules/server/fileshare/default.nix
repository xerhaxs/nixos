{ config, lib, pkgs, ... }:

{ 
  options.nixos = {
    server.fileshare = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable fileshare modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fileshare.enable {
    imports = [
      ./samba.nix
      ./webdav.nix
    ];
  };
}

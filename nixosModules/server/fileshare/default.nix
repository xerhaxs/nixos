{ config, lib, pkgs, ... }:

with lib;

{ 
  options.nixos = {
    server.fileshare = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable fileshare modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.server.fileshare.enable {
    imports = [
      ./samba.nix
      ./webdav.nix
    ];
  };
}

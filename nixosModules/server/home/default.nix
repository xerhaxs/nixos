{ config, lib, pkgs, ... }:

{ 
  imports = [
    #./etesync.nix
    #./firefoxsync.nix
    #./haos.nix
    #./homeassistant.nix
    ./jellyfin.nix
    #./mailserver.nix
    ./nextcloud.nix
    #./onlyoffice.nix
    #./pufferpanel.nix
    #./radicale.nix
    #./vaultwarden.nix
  ];

  options.nixos = {
    server.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.enable {
    nixos.server.home = {
      #etesync.enable = true;
      #firefoxsync.enable = true;
      #haos.enable = true;
      #homeassistant.enable = true;
      jellyfin.enable = true;
      #mailserver.enable = true;
      nextcloud.enable = true;
      #onlyoffice.enable = true;
      #pufferpanel.enable = true;
      #radicale.enable = true;
    };
  };
}

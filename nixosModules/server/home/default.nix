{ config, lib, pkgs, ... }:

{ 
  options.nixos = {
    server.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.enable {
    imports = [
      ./etesync.nix
      ./firefoxsync.nix
      ./haos.nix
      ./homeassistant.nix
      ./jellyfin.nix
      ./mailserver.nix
      ./nextcloud.nix
      ./onlyoffice.nix
      ./pufferpanel.nix
      ./radicale.nix
      ./vaultwarden.nix
    ];
  };
}

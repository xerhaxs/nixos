{ config, lib, pkgs, ... }:

with lib;

{ 
  options.nixos = {
    server.home = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.server.home.enable {
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

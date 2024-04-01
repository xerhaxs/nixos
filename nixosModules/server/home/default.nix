{ pkgs, lib, config, ... }: 

{ 
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
}

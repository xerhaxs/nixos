{ config, lib, pkgs, ... }:

{
  imports = [
    ./autostart
    ./flatpak.nix
    ./gamemode.nix
    ./gamescope.nix
    ./heroic.nix
    ./kdeconnect.nix
    ./mullvad.nix
    ./printing.nix
    ./samba-client.nix
    ./steam.nix
    ./syncthing.nix
  ];

  options.nixos = {
    userEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable userEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.enable {
    nixos.userEnvironment = {
      autostart.enable = true;
      flatpak.enable = false;
      gamemode.enable = true;
      gamescope.enable = true;
      heroic.enable = true;
      kdeconnect.enable = true;
      mullvad.enable = true;
      printing.enable = true;
      samba-client.enable = true;
      steam.enable = true;
      syncthing.enable = true;
    };
  };
}

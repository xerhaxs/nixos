{ config, lib, pkgs, ... }:

{
  imports = [
    ./config
    ./game
    ./io

    ./appimage.nix
    ./dconf.nix
    ./fonts.nix
    ./gamemode.nix
    ./gamescope.nix
    ./kdeconnect.nix
    ./mullvad.nix
    ./nfs-client.nix
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
      config.enable = true;
      io.enable = true;

      appimage.enable = true;
      dconf.enable = true;
      fonts.enable = true;
      gamemode.enable = true;
      gamescope.enable = true;
      kdeconnect.enable = true;
      mullvad.enable = true;
      nfs-client.enable = true;
      samba-client.enable = true;
      steam.enable = true;
      syncthing.enable = true;
    };
  };
}

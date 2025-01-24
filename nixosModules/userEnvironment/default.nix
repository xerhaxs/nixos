{ config, lib, pkgs, ... }:

{
  imports = [
    ./autostart
    ./config
    ./flatpak.nix
    ./gamemode.nix
    ./gamescope.nix
    ./kdeconnect.nix
    ./mullvad.nix
    ./nfs-client.nix
    ./ollama.nix
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
      config.enable = true;
      flatpak.enable = false;
      gamemode.enable = true;
      gamescope.enable = true;
      kdeconnect.enable = true;
      mullvad.enable = true;
      nfs-client.enable = true;
      ollama.enable = true;
      printing.enable = true;
      samba-client.enable = true;
      steam.enable = true;
      syncthing.enable = true;
    };
  };
}

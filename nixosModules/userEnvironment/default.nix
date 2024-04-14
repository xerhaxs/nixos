{ config, lib, pkgs, ... }:

{
  imports = [
    ./autostart
    ./flatpak.nix
    ./gamemode.nix
    ./kdeconnect.nix
    ./mullvad.nix
    ./printing.nix
    ./samba-client.nix
    ./xdgmime.nix
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
      flatpak.enable = true;
      gamemode.enable = false;
      kdeconnect.enable = true;
      mullvad.enable = true;
      printing.enable = true;
      samba-client.enable = true;
      xdgmime.enable = true;
    };
  };
}

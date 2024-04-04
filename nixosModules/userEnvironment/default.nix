{ config, lib, pkgs, ... }:

{
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
  };
}

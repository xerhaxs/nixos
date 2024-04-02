{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable userEnvironment modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.enable {
    imports = [
      ./autostart
      ./flatpak.nix
      ./gamemode.nix
      ./kdeconnect.nix
      ./printing.nix
    ];
  };
}

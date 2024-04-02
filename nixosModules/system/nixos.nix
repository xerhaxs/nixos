{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.nixos = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable the default NixOS settings.";
      };
    };
  };

  config = mkIf config.nixos.system.nixos.enable {
    nixpkgs.config.allowUnfree = true;

    programs.nix-ld.enable = true;

    system.autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };

    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        sandbox = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    system.stateVersion = "24.05";
  };
}
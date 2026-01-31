{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.nixos = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the default NixOS settings.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.nixos.enable {
    nixpkgs.config.allowUnfree = false;

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # nixosModules/base/tools/common.nix
      "unrar"

      # nixosModules/hardware/amdcpu.nix + nixosModules/hardware/intelcpui.nix
      #"b43-firmware"
      #"broadcom-bt-firmware"
      #"facetimehd-calibration"
      #"facetimehd-firmware"
      #"xow_dongle-firmware"

      # nixosModules/userEnvironment/game/steam.nix
      "steam"
      "steam-unwrapped"
    ];

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
        automatic = false;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    system.stateVersion = "25.11";

    environment.systemPackages = with pkgs; [
      nix-output-monitor # nix related
      nix-prefetch
      nixos-generators
    ];

    programs.command-not-found.enable = false;

    programs.nix-index.enable = true;
  };
}
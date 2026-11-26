{
  config,
  lib,
  pkgs,
  ...
}:

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

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "unrar"

        "ventoy"

        "lsfg-vk"

        "vscode-extension-anthropic-claude-code"

        "minecraft-server"

        "steam"
        "steam-unwrapped"

        "via"
        "xone-dongle-firmware"

        "cups-kyocera-ecosys-m2x35-40-p2x35-40dnw"
      ];

    nixpkgs.config.permittedInsecurePackages = [
      # CVE-2026-120459 (forged JWTs with an empty HMAC key) concerns services that verify tokens,
      # here it is only pulled in by the woob plugin of KMyMoney. Remove once nixpkgs has a fix.
      "python3.14-python-jose-3.5.0"
      "ventoy-1.1.18"
    ];

    programs.nix-ld.enable = lib.mkDefault config.nixos.desktop.enable;

    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        sandbox = true;

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      gc = {
        automatic = false;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    environment.systemPackages = with pkgs; [
      nix-output-monitor
      nix-prefetch
      nixos-generators
      nixfmt
      nixd
    ];

    programs.command-not-found.enable = false;

    programs.nix-index.enable = true;

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/etc/nixos"
        "/var/lib/nixos"
      ];
    };
  };
}

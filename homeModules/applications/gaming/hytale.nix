{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.gaming.hytale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the Hytale launcher (flake input hytale-launcher, FHS-wrapped so the launcher can update the game).";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.hytale.enable {
    home.packages = [ inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/Hytale"
      ];
    };
  };
}

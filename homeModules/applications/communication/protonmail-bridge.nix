{
  config,
  lib,
  pkgs,
  osConfig
  ...
}:

{
  options.homeManager = {
    applications.communication.protonmail-bridge = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Protonmail bridge.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.protonmail-bridge.enable {
    services.protonmail-bridge = {
      enable = true;
      logLevel = "info";
      package = pkgs.protonmail-bridge;
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/protonmail"
        ".local/share/protonmail"
      ];
    };
  };
}

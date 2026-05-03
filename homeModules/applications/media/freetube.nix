{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.media.freetube = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable freetube";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.freetube.enable {
    home.packages = with pkgs; [
      freetube
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/FreeTube"
      ];
    };
  };
}

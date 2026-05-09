{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.development.singleboardcomputer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Single-Board Computer software.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.singleboardcomputer.enable {
    home.packages = with pkgs; [
      esphome
      fritzing
      rpi-imager
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/Fritzing"
        ".local/share/Fritzing"
      ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.development.bottles = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bottles.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.bottles.enable {
    home.packages = with pkgs; [
      bottles
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/bottles"
      ];
    };
  };
}

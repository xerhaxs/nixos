{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.editing.tenacity = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tenacity";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.tenacity.enable {
    home.packages = with pkgs; [
      tenacity
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/tenacity"
      ];
    };
  };
}

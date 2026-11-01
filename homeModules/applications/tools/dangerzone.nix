{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.tools.dangerzone = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Dangerzone (needs nixos.virtualisation.podman).";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.dangerzone.enable {
    assertions = [
      {
        assertion = osConfig.nixos.virtualisation.podman.enable;
        message = "Dangerzone runs its conversions in rootless podman, enable nixos.virtualisation.podman.";
      }
    ];

    home.packages = with pkgs; [
      dangerzone
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/dangerzone"
        ".local/share/containers"
        ".local/share/dangerzone"
      ];
    };
  };
}

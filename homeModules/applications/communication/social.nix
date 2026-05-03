{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.communication.social = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable social communication apps.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.social.enable {
    home.packages = with pkgs; [
      briar-desktop
      element-desktop
      mumble
      signal-desktop
      telegram-desktop
      wasistlos
    ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".briar"
        ".config/Element"
        ".config/Mumble"
        ".local/share/Mumble"
        ".config/Signal"
        ".local/share/TelegramDesktop"
      ];
    };
  };
}

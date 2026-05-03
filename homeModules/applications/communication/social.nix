{
  config,
  lib,
  pkgs,
  osConfig,
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
      karere
    ];

    home.activation.cleanElementSingletons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for f in \
        "$HOME/.config/Element/SingletonCookie" \
        "$HOME/.config/Element/SingletonLock" \
        "$HOME/.config/Element/SingletonSocket"; do
        [ -L "$f" ] && rm -f "$f"
      done
    '';

    home.activation.cleanSignalSingletons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for f in \
        "$HOME/.config/Signal/SingletonCookie" \
        "$HOME/.config/Signal/SingletonLock" \
        "$HOME/.config/Signal/SingletonSocket"; do
        [ -L "$f" ] && rm -f "$f"
      done
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
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

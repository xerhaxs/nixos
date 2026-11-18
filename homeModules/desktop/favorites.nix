{
  config,
  lib,
  osConfig,
  ...
}:

{
  options.homeManager = {
    desktop.favorites = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "virt-manager"
        "qalculate-gtk"
        "org.kde.dolphin"
        "librewolf"
        "thunderbird"
        "org.kde.merkuro.calendar"
        "org.kde.kate"
        "codium"
        "signal"
        "org.telegram.desktop"
        "io.github.tobagin.karere"
        "legcord"
        "org.kde.kmymoney"
        "org.kde.kile"
        "writer"
        "calc"
        "impress"
        "com.github.flxzt.rnote"
        "com.obsproject.Studio"
        "org.clementine_player.Clementine"
        "fluent-reader"
        "freetube"
      ]
      ++ lib.optionals osConfig.nixos.userEnvironment.game.enable [
        "org.prismlauncher.PrismLauncher"
        "com.heroicgameslauncher.hgl"
        "steam"
      ]
      ++ lib.optionals config.homeManager.applications.vpn.enable [
        "mullvad-vpn"
      ];
      defaultText = lib.literalMD "The applications of the Plasma task bar.";
      description = "Desktop entry ids (without `.desktop`) of the favorite applications, shared by the Plasma task bar and the Hyprland launcher.";
    };

    desktop.favoritesExclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "com.obsproject.Studio" ];
      description = "Entries of desktop.favorites left out on this host.";
    };

    desktop.favoritesShown = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
      default = lib.subtractLists config.homeManager.desktop.favoritesExclude config.homeManager.desktop.favorites;
      defaultText = lib.literalExpression "favorites without favoritesExclude";
      description = "The favorites this host shows (task bar, start menu, Hyprland launcher).";
    };
  };
}

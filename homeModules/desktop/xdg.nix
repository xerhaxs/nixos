{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.xdg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable xdg settings.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.xdg.enable {
    # flake.nix reads the private repository through this link.
    home.file.".nixos-private" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.userDirs.documents}/nixos-private";
      force = true;
    };

    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";
      dataHome = config.home.homeDirectory + "/.local/share";
      configHome = config.home.homeDirectory + "/.config";
      stateHome = config.home.homeDirectory + "/.local/state";

      mimeApps = {
        enable = true;
        defaultApplications = osConfig.xdg.mime.defaultApplications;
        associations.added = osConfig.xdg.mime.addedAssociations;
      };

      autostart.enable = true;

      #configFile."mimeapps.list".enable = false;
      #dataFile."applications/mimeapps.list".force = true;

      configFile."mimeapps.list" = lib.mkIf config.xdg.mimeApps.enable { force = true; };

      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          SCREENSHOTS = "${config.xdg.userDirs.desktop}";
          GAMES = lib.mkDefault "${config.home.homeDirectory}/Games";
        };
      };
    };
  };
}

{ config, lib, osConfig, pkgs, ... }:

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
    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";

      mimeApps = {
        enable = true;
        defaultApplications = osConfig.xdg.mime.defaultApplications;
        associations.added = osConfig.xdg.mime.addedAssociations;
      };

      #configFile."mimeapps.list".enable = false;
      #dataFile."applications/mimeapps.list".force = true;

      configFile."mimeapps.list" = lib.mkIf config.xdg.mimeApps.enable { force = true; };

      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.desktop}";
          XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
        };
      };
    };
  };
}


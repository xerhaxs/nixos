{ config, pkgs, ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
        savePath = "${config.xdg.userDirs.desktop}";
        saveAsFileExtension = ".png";
        uiColor = "#740096";
        contrastUiColor = "#270032";
        showHelp = false;
        showDesktopNotification = true;
        filenamePattern = "%F_%T";
        disabledTrayIcon = true;
        autoCloseIdleDaemon = false;
        allowMultipleGuiInstances = false;
        startupLaunch = true;
        saveAfterCopy = true;
        copyPathAfterSave = true;
        uploadWithoutConfirmation = false;
      };
    };
  };
}


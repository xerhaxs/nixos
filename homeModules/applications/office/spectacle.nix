{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.desktopEnvironment.plasma6.spectacle = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable spectacle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.plasma6.spectacle.enable {
    xdg.configFile."spectaclerc".text = ''
      [Annotations]
      annotationToolType=7
      rectangleFillColor=255,0,0,0
      rectangleStrokeColor=255,0,0

      [General]
      autoSaveImage=true
      clipboardGroup=PostScreenshotCopyImage
      closeAfterOcr=true
      ocrLanguages=deu,eng

      [GuiConfig]
      includePointer=true

      [ImageSave]
      imageSaveLocation=file://${config.xdg.userDirs.desktop}
      translatedScreenshotsFolder=Screenshots

      [VideoSave]
      translatedScreencastsFolder=Screencasts
      videoSaveLocation=file://${config.xdg.userDirs.desktop}
    '';
  };
}

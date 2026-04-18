{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.office.joplin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable joplin desktop.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.joplin.enable {
    programs.joplin-desktop = {
      enable = true;
      package = pkgs.joplin-desktop;
      general.editor = "kate";
      sync = {
        interval = "5m";
        target = "webdav";
      };
      extraConfig = {
        "editor.codeView" = true;
        "locale" = "en_GB";
        "dateFormat" = "YYYY-MM-DD";
        "ocr.handwrittenTextDriverEnabled" = true;
        #"theme": 2,
        #"preferredLightTheme": 1,
        "markdown.plugin.softbreaks" = false;
        "markdown.plugin.typographer" = false;
        "editor.spellcheckBeta" = true;
        "revisionService.ttlDays" = 365;
        "spellChecker.languages" = [
          "en-US"
          "de"
        ];
        "trash.autoDeletionEnabled" = true;
      };
    };
  };
}

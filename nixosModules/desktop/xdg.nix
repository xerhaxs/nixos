{
  config,
  lib,
  pkgs,
  ...
}:

let
  browser = [ "librewolf.desktop;" ];
  chrome = [ "brave.desktop;" ];
  filemanager = [ "org.kde.dolphin.desktop;" ];
  videoplayer = [ "mpv.desktop;" ];
  musicplayer = [ "mpv.desktop;" ];
  pdfviewer = [ "org.kde.okular.desktop;" ];
  imageviewer = [ "org.kde.gwenview.desktop;" ];
  editor = [ "org.kde.kate.desktop;" ];
  freetube = [ "freetube.desktop;" ];
  signal = [ "signal-desktop.desktop;" ];
  discord = [ "com.discordapp.Discord.desktop;" ];
  maps = [ "openstreetmap-geo-handler.desktop;" ];
  mail = [ "thunderbird.desktop;" ];
  calendar = [ "org.kde.merkuro.calendar.desktop;" ];
  imageeditor = [ "gimp.desktop;" ];
  xournal = [ "com.github.xournalpp.xournalpp.desktop;" ];

  # Source and config files open in Kate, not in a terminal, vim or a browser (scripts are not run on
  # a double click).
  code = [
    "application/javascript"
    "application/sql"
    "application/toml"
    "application/x-perl"
    "application/x-php"
    "application/x-shellscript"
    "application/x-yaml"
    "application/xml"
    "text/css"
    "text/javascript"
    "text/rust"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-cmake"
    "text/x-csrc"
    "text/x-diff"
    "text/x-go"
    "text/x-java"
    "text/x-log"
    "text/x-lua"
    "text/x-makefile"
    "text/x-nix"
    "text/x-patch"
    "text/x-python"
    "text/x-python3"
    "text/x-rust"
    "text/x-shellscript"
    "text/x-sql"
    "text/xml"
  ];

  # LibreOffice: the types each application lists in its desktop file. Not text/plain (Kate) and
  # application/pdf (Okular); clarisworks and ms-works go to Writer (listed by several).
  office = {
    "writer.desktop" = [
      "application/clarisworks"
      "application/docbook+xml"
      "application/macwriteii"
      "application/msword"
      "application/prs.plucker"
      "application/rtf"
      "application/vnd.apple.pages"
      "application/vnd.lotus-wordpro"
      "application/vnd.ms-word"
      "application/vnd.ms-word.document.macroEnabled.12"
      "application/vnd.ms-word.template.macroEnabled.12"
      "application/vnd.ms-works"
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.text-flat-xml"
      "application/vnd.oasis.opendocument.text-master"
      "application/vnd.oasis.opendocument.text-master-template"
      "application/vnd.oasis.opendocument.text-template"
      "application/vnd.oasis.opendocument.text-web"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
      "application/vnd.palm"
      "application/vnd.stardivision.writer-global"
      "application/vnd.sun.xml.writer"
      "application/vnd.sun.xml.writer.global"
      "application/vnd.sun.xml.writer.template"
      "application/vnd.wordperfect"
      "application/wordperfect"
      "application/x-abiword"
      "application/x-aportisdoc"
      "application/x-doc"
      "application/x-fictionbook+xml"
      "application/x-hwp"
      "application/x-iwork-pages-sffpages"
      "application/x-mswrite"
      "application/x-pocket-word"
      "application/x-sony-bbeb"
      "application/x-starwriter"
      "application/x-starwriter-global"
      "application/x-t602"
      "text/rtf"
    ];
    "calc.desktop" = [
      "application/csv"
      "application/excel"
      "application/msexcel"
      "application/tab-separated-values"
      "application/vnd.apache.parquet"
      "application/vnd.apple.numbers"
      "application/vnd.lotus-1-2-3"
      "application/vnd.ms-excel"
      "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
      "application/vnd.ms-excel.sheet.macroEnabled.12"
      "application/vnd.ms-excel.template.macroEnabled.12"
      "application/vnd.oasis.opendocument.chart"
      "application/vnd.oasis.opendocument.chart-template"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.spreadsheet-flat-xml"
      "application/vnd.oasis.opendocument.spreadsheet-template"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
      "application/vnd.stardivision.calc"
      "application/vnd.stardivision.chart"
      "application/vnd.sun.xml.calc"
      "application/vnd.sun.xml.calc.template"
      "application/x-123"
      "application/x-dbase"
      "application/x-dbf"
      "application/x-dos_ms_excel"
      "application/x-excel"
      "application/x-gnumeric"
      "application/x-iwork-numbers-sffnumbers"
      "application/x-ms-excel"
      "application/x-msexcel"
      "application/x-quattropro"
      "application/x-starcalc"
      "application/x-starchart"
      "text/comma-separated-values"
      "text/csv"
      "text/spreadsheet"
      "text/tab-separated-values"
      "text/x-comma-separated-values"
      "text/x-csv"
    ];
    "impress.desktop" = [
      "application/mspowerpoint"
      "application/vnd.apple.keynote"
      "application/vnd.ms-powerpoint"
      "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
      "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
      "application/vnd.ms-powerpoint.template.macroEnabled.12"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.oasis.opendocument.presentation-flat-xml"
      "application/vnd.oasis.opendocument.presentation-template"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.openxmlformats-officedocument.presentationml.slide"
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
      "application/vnd.openxmlformats-officedocument.presentationml.template"
      "application/vnd.stardivision.impress"
      "application/vnd.sun.xml.impress"
      "application/vnd.sun.xml.impress.template"
      "application/x-iwork-keynote-sffkey"
      "application/x-starimpress"
    ];
    "draw.desktop" = [
      "application/vnd.corel-draw"
      "application/vnd.ms-publisher"
      "application/vnd.oasis.opendocument.graphics"
      "application/vnd.oasis.opendocument.graphics-flat-xml"
      "application/vnd.oasis.opendocument.graphics-template"
      "application/vnd.quark.quarkxpress"
      "application/vnd.stardivision.draw"
      "application/vnd.sun.xml.draw"
      "application/vnd.sun.xml.draw.template"
      "application/vnd.visio"
      "application/x-pagemaker"
      "application/x-stardraw"
      "application/x-wpg"
      "image/x-emf"
      "image/x-freehand"
      "image/x-wmf"
    ];
    "math.desktop" = [
      "application/mathml+xml"
      "application/vnd.oasis.opendocument.formula"
      "application/vnd.oasis.opendocument.formula-template"
      "application/vnd.stardivision.math"
      "application/vnd.sun.xml.math"
      "application/x-starmath"
      "text/mathml"
    ];
    "base.desktop" = [
      "application/vnd.oasis.opendocument.base"
      "application/vnd.sun.xml.base"
    ];
  };

  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "x-scheme-handler/tg" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = chrome;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = editor;
    "application/octet-stream" = editor;
    "text/plain" = editor;
    "text/markdown" = editor;
    "text/html" = editor;
    "audio/*" = musicplayer;
    "video/*" = videoplayer;
    "image/*" = imageviewer;
    "application/json" = browser;
    "application/pdf" = pdfviewer;
    "x-scheme-handler/freetube" = freetube;
    "x-scheme-handler/sgnl" = signal;
    "x-scheme-handler/signalcaptcha" = signal;
    "x-scheme-handler/discord" = discord;
    "inode/directory" = filemanager;
    "x-scheme-handler/geo" = maps;
    "x-scheme-handler/mailto" = mail;
    "x-scheme-handler/mid" = mail;
    "message/rfc822" = mail;
    "application/geo+json" = maps;
    # Okular instead of Dangerzone (epub) and Gwenview (djvu, image/*).
    "application/epub+zip" = [ "okularApplication_epub.desktop;" ];
    "image/vnd.djvu" = [ "okularApplication_djvu.desktop;" ];
    "image/x-djvu" = [ "okularApplication_djvu.desktop;" ];
    "application/vnd.comicbook+zip" = [ "okularApplication_comicbook.desktop;" ];
    "application/vnd.comicbook-rar" = [ "okularApplication_comicbook.desktop;" ];
    "image/x-xcf" = imageeditor;
    "application/x-xopp" = xournal;
    "text/calendar" = calendar;
    "text/vcard" = mail;
    "text/x-vcard" = mail;
  }
  // lib.concatMapAttrs (app: types: lib.genAttrs types (_: [ "${app};" ])) office
  // lib.genAttrs code (_: editor);
in

{
  options.nixos = {
    desktop.xdg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable XDG Portal settings.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.xdg.enable {
    xdg = {
      portal = {
        enable = true;
        wlr = {
          enable = true;
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
        config = {
          common.default = "kde";
          hyprland.default = [
            "hyprland"
            "gtk"
          ];
        };
      };

      mime = {
        enable = true;
        defaultApplications = associations;
        addedAssociations = associations;
      };

      autostart.enable = true;
    };
  };
}

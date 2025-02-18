{ config, lib, pkgs, ... }:

let
  browser = [ "firefox.desktop;" ];
  chrome = [ "brave-browser.desktop;" ];
  filemanager = [ "org.kde.dolphin.desktop;"] ;
  mediaplayer = [ "mpv.desktop;" ];
  videoplayer = [ "mpv.desktop;" ];
  musicplayer = [ "mpv.desktop;" ];
  pdfviewer = [ "org.kde.okular.desktop;" ];
  imageviewer = [ "org.kde.gwenview.desktop;" ];
  editor = [ "org.kde.kate.desktop;" ];
  freetube = [ "freetube.desktop;" ];
  signal = [ "signal-desktop.desktop;" ];
  discord = [ "com.discordapp.Discord.desktop;" ];

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
    "text/plain" = editor;
    "text/markdown"= editor;
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
  };
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
          #settings = {};
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal
        #  xdg-desktop-portal-wlr
        #  xdg-desktop-portal-kde
        #  xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        #config.common.default = "*";
        #xdgOpenUsePortal = true;
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

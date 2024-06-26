{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.browser.librewolf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Librewolf browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.librewolf.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "browser.contentblocking.category" = "strict";
        "browser.download.panel.shown" = true;
        "webgl.disabled" = false;
        "network.http.referer.XOriginPolicy" = 2;
        "media.autoplay.blocking_policy" = 2;
        "security.OCSP.require" = false; # disable ocsp hard-fail
        "widget.use-xdg-desktop-portal.mime-handler" = 1; # set system file dialog
        "dom.w3c.touch_events.enabled" = true; #touch support aktivieren
        "browser.download.improvements_to_download_panel" = false; # disable "fast" Download
        "browser.backspace_action" = 0; # Browser Backspace enable
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # enable theming
        "general.autoScroll" = true; # enable autoscroll
        "media.navigator.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "xpinstall.signatures.required" = false;
        "widget.use-xdg-desktop-portal.file-pcker" = 1;
        "intl.accept_languages" = "de,en-US";
        "network.dns.disableIPv6" = true;
        "privacy.firstparty.isolate" = false;
        "geo.enabled" = false;
        "dom.security.https_only_mode_ever_enabled" = true;
        "media.eme.enabled" = true;
        "privacy.resistFingerprinting" = false;
        "network.captive-portal-service.enabled" = true;
        "security.enterprise_roots.enabled" = true;
        #"widget.use-xdg-desktop-portal.location" = 1;
        #"widget.use-xdg-desktop-portal.mime-handler" = 1;
        #"widget.use-xdg-desktop-portal.open-uri" = 1;
        #"widget.use-xdg-desktop-portal.settings" = 1;

        "browser.policies.runOncePerModification.extensionsInstall" = "https://addons.mozilla.org/firefox/downloads/file/4208483/return_youtube_dislikes-3.0.0.14.xpi";
      };
    };
  };
}

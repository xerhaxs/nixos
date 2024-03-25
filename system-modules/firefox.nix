{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = false;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;

      DisableSecurityBypass = {
        InvalidCertificate = false;
        SafeBrowsing = false;
      }; 

      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";
      DNSOverHTTPS = "Enabled";
      DontCheckDefaultBrowser = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        Exceptions = [
         #
        ];
      };

      EncryptedMediaExtensions.Enabled = false;

      media.ffmpeg.vaapi.enabled = true;

      ExtensionUpdate = true;

      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };

      GoToIntranetSiteForSingleWordEntryInAddressBar = false;

      HardwareAcceleration = true;
      Homepage.StartPage = "homepage";
      LegacySameSiteCookieBehaviorEnabled = false;
      NetworkPrediction = true;
      NewTabPage = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "about:blank";
      PasswordManagerEnabled = false;

      Permissions = {
        Camera.BlockNewRequests = false;
        Microphone.BlockNewRequests = false;
        Location.BlockNewRequests = true;
        Autoplay.Default = "block-audio-video";
      }; 

      PopupBlocking.Default = true;

      Preferences = {
        browser.tabs.warnOnClose = false;
      };

      PromptForDownloadLocation = true;
      RequestedLocales = "de-DE";
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        Downloads = true;
        FormData = true;
        History = true;
        Sessions = true;
        SiteSettings = false;
        OfflineApps = true;
        Locked = true;
      };
      SearchBar = "separate";
      
      SearchSuggestEnabled = true;
      
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
      };

      UseSystemPrintDialog = true;
    };

    #nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
  };
}

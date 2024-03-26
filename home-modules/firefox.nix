{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      keepassxc
      libsForQt5.plasma-browser-integration
    ];

    policies = {
      CaptivePortal = true;

      BlockAboutConfig = false;
      DefaultDownloadDirectory = "\${home}/Downloads";

      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableSafeMode = true;
      DisableSetDesktopBackground = true;

      DisableSecurityBypass = {
        InvalidCertificate = false;
        SafeBrowsing = false;
      }; 

      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";
      DNSOverHTTPS = "Enabled";
      DontCheckDefaultBrowser = true;
      EnterprisePoliciesEnabled = true;

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

      PrintingEnabled = true;

      EncryptedMediaExtensions.Enabled = true;

      ExtensionSettings = {
        "{60f82f00-9ad5-4de5-b31c-b16a47c51558}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/cookie_quick_manager/latest.xpi";
        };
        "addon@darkreader.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
        "floccus@handmadeideas.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/floccus/latest.xpi";
        };
        "idcac-pub@guus.ninja" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
        };
        "keepassxc-browser@keepassxc.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc_browser/latest.xpi";
        };
        "kiwix-html5-listed@kiwix.org" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latestkiwix_offline/latest.xpi";
        };
        "7esoorv3@alefvanoon.anonaddy.me" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
        };
        "{9efc0280-b125-400e-b53d-2d09d7effab4}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/mitaka/latest.xpi";
        };
        "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
        };
        "addon@simplelogin" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/simplelogin/latest.xpi";
        };
        #"{b11bea1f-a888-4332-8d8a-cec2be7d24b9}" = {
        #  "installation_mode" = "force_installed";
        #  "install_url" = "https://addons.mozilla.org/en-US/developers/addon/torproject-snowflake/versions";
        #};
        "uBlock0@raymondhill.net" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/user_agent_string_switcher/latest.xpi";
        };
        "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/video_downloadhelper/latest.xpi";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/vimium_ff/latest.xpi";
        };
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
        };
        "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/view_page_archive/latest.xpi";
        };
      };

      media.ffmpeg.vaapi.enabled = true;

      ExtensionUpdate = true;

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };

      ManagedBookmarks = [
        {
          name = "NixOS Changelog";
          keyword = "changelog";
          url = "https://nixos.org/manual/nixos/unstable/release-notes";
          toolbar = true;
        }
        {
          name = "Schule";
          toolbar = true;
          bookmarks = [
            {
              name = "Teams";
              keyword = "teams";
              url = "https://teams.microsoft.com";
            }
            {
              name = "GyWi";
              keyword = "gywi";
              url = "https://gywi.de/";
            }
          ];
        }
      ];

      Containers = {
        Amazon = {
          color = "red";
          icon = "fence";
          id = 1;
        };
        ChatGPT = {
          color = "red";
          icon = "fence";
          id = 2;
        };
        Disney = {
          color = "red";
          icon = "fence";
          id = 3;
        };
        Instagram = {
          color = "red";
          icon = "fence";
          id = 4;
        };
        Netflix = {
          color = "red";
          icon = "fence";
          id = 5;
        };
        Proton = {
          color = "blue";
          icon = "fingerprint";
          id = 6;
        };
        Teams = {
          color = "red";
          icon = "fence";
          id = 7;
        };
        Twitch = {
          color = "red";
          icon = "fence";
          id = 8;
        };
      };

      SearchEngines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nw" ];
        };
      };

      #Handlers = {
#
 #     };

      GoToIntranetSiteForSingleWordEntryInAddressBar = false;

      HardwareAcceleration = true;
      Homepage.StartPage = "homepage";
      LegacySameSiteCookieBehaviorEnabled = false;
      NetworkPrediction = true;
      NewTabPage = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "about:blank";
      OverridePostUpdatePage = "about:blank";
      PasswordManagerEnabled = false;
      PDFjs.Enabled = true;

      Permissions = {
        Camera.BlockNewRequests = false;
        Microphone.BlockNewRequests = false;
        Location.BlockNewRequests = true;
        Notifications.BlockNewRequests = true;
        Autoplay.Default = "block-audio-video";
      }; 

      PrimaryPassword = false;

      PopupBlocking.Default = true;
      PictureInPicture = true;

      Preferences = {
        browser.tabs.warnOnClose = true;
      };

      PromptForDownloadLocation = true;
      RequestedLocales = [ "de-DE" "en-US" ];
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        Downloads = true;
        FormData = true;
        History = true;
        Sessions = true;
        SiteSettings = true;
        OfflineApps = true;
        Locked = true;
      };
      SearchBar = "separate";

      #Proxy = 

      #SearchEngines.Add = {
      #  Name = "Such-O-Mat";

        #Name = "DuckDuckGo";

        #Name = "MetaGer";

        #Name = "Brave";

        #Name = "Qwant";

        #Name = "Startpage";

       # Name = "Wikipedia";

       # Name = "Ahmia";


      #};
      
      SearchSuggestEnabled = true;
      
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
      };

      ShowHomeButton = true;

      StartDownloadsInTempDirectory = false;

      Cookies = "reject-tracker-and-partition-foreign";

      UseSystemPrintDialog = true;

      FirefoxSuggest = {
        WebSuggestions = true;
        SponsoredSuggestions = false;
        ImproveSuggest = true;
        Locked = true;
      };
    };
#    settings = {
#      "webgl.disabled" = true;
#      "network.http.referer.XOriginPolicy" = 2;
#      "media.autoplay.blocking_policy" = 2;
#      "security.OCSP.require" = false;
#    };
  };
}

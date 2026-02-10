{ config, lib, pkgs, ... }:

let
  customization = {
    # Translation
    "browser.translations.panelShown" = true;
    "browser.translations.neverTranslateLanguages" = "de,en";

    # set HOME+NEWWINDOW page
    "browser.startup.homepage" = "https://glance.m4rx.cc/";

    # enable user interaction for security by always asking where to download
    "browser.download.useDownloadDir" = false;

    # enable downloads panel opening on every download [FF96+]
    "browser.download.alwaysOpenPanel" = true;

    # enable adding downloads to the system's "recent documents" list
    "browser.download.manager.addToRecentDocs" = true;

    # enable user interaction for security by always asking how to handle new mimetypes [FF101+]
    "browser.download.always_ask_before_handling_new_types" = true;

    # set new window size rounding max values [FF55+]
    "privacy.window.maxInnerWidth" = 2200;
    "privacy.window.maxInnerHeight" = 1200;

    # mime system handler
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    "widget.use-xdg-desktop-portal.file-picker" = 1;

    # go back with backspace
    "browser.backspace_action" = 0;

    # enable system titlebar
    "browser.tabs.inTitlebar" = 0;

    # prefer system print dialog
    "print.prefer_system_dialog" = true;

    # show full url in urlbar
    "browser.urlbar.trimURLs" = false;

    # warn on close
    "browser.tabs.warnOnClose" = true;

    # enable vaapi ffmpeg support
    "media.ffmpeg.vaapi.enabled" = true;

    # enable enterprise policies
    "security.enterprise_roots.enabled" = true;

    # always display bookmarks toolbar
    "browser.toolbars.bookmarks.visibility" = "always";

    # customize librewolf toolbars
    "browser.uiCustomization.state" = {
      "placements" = {
        "widget-overflow-fixed-list" = [ ];
        "unified-extensions-area" = [
          "addon_darkreader_org-browser-action"
          "idcac-pub_guus_ninja-browser-action"
          "plasma-browser-integration_kde_org-browser-action"
          "canvasblocker_kkapsner_de-browser-action"
        ];
        "nav-bar" = [
          "back-button"
          "forward-button"
          "stop-reload-button"
          "history-panelmenu"
          "urlbar-container"
          "search-container"
          "bookmarks-menu-button"
          "downloads-button"
          "privatebrowsing-button"
          "developer-button"
          "keepassxc-browser_keepassxc_org-browser-action"
          "floccus_handmadeideas_org-browser-action"
          "fxa-toolbar-menu-button"
          "addon_simplelogin-browser-action"
          "ublock0_raymondhill_net-browser-action"
          "unified-extensions-button"
        ];
        "toolbar-menubar" = [ "menubar-items" ];
        "TabsToolbar" = [ 
          "tabbrowser-tabs"
          "new-tab-button"
          "alltabs-button"
        ];
        "PersonalToolbar" = [ 
          "managed-bookmarks"
          "personal-bookmarks" 
        ];
      };
      "seen" = [
        "developer-button"
        "addon_simplelogin-browser-action"
        "idcac-pub_guus_ninja-browser-action"
        "floccus_handmadeideas_org-browser-action"
        "ublock0_raymondhill_net-browser-action"
        "keepassxc-browser_keepassxc_org-browser-action"
        "plasma-browser-integration_kde_org-browser-action"
        "canvasblocker_kkapsner_de-browser-action"
      ];
      "dirtyAreaCache" = [
        "nav-bar"
        "PersonalToolbar"
        "unified-extensions-area"
        "TabsToolbar"
      ];
      "currentVersion" = 20;
      "newElementCount" = 8;
    };  
  };
in

{
  options.homeManager = {
    applications.browser.librewolf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable librewolf browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.librewolf.enable {
    programs.librewolf = {
      enable = true;
      #package = pkgs.librewolf-unwrapped.override {
      #  pipewireSupport = true;
      #  #alsaSupport = true;
      #};

      nativeMessagingHosts = with pkgs; [
        kdePackages.plasma-browser-integration
      ];

      settings = {
        #"privacy.resistFingerprinting" = false;
        #"security.OCSP.require" = false;
        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;
        "browser.safebrowsing.blockedURIs.enabled" = true;
        "browser.safebrowsing.provider.google4.gethashURL" = "https://safebrowsing.googleapis.com/v4/fullHashes:find?$ct=application/x-protobuf&key=%GOOGLE_SAFEBROWSING_API_KEY%&$httpMethod=POST";
        "browser.safebrowsing.provider.google4.updateURL" = "https://safebrowsing.googleapis.com/v4/threatListUpdates:fetch?$ct=application/x-protobuf&key=%GOOGLE_SAFEBROWSING_API_KEY%&$httpMethod=POST";
        "browser.safebrowsing.provider.google.gethashURL" = "https://safebrowsing.google.com/safebrowsing/gethash?client=SAFEBROWSING_ID&appver=%MAJOR_VERSION%&pver=2.2";
        "browser.safebrowsing.provider.google.updateURL" = "https://safebrowsing.google.com/safebrowsing/downloads?client=SAFEBROWSING_ID&appver=%MAJOR_VERSION%&pver=2.2&key=%GOOGLE_SAFEBROWSING_API_KEY%";

        #"webgl.disabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "image.jxl.enabled" = true;
        "media.eme.enabled" = true;

        "browser.eme.ui.enabled" = true;
        "media.autoplay.blocking_policy" = 2;
        "cookiebanners.service.mode" = 2;
        "general.autoScroll" = true;
        "middlemouse.paste" = false;
        "browser.backspace_action" = 0;
      };

      policies = {
        DefaultDownloadDirectory = "\${home}/Downloads";

        DontCheckDefaultBrowser = true;
        EnterprisePoliciesEnabled = true;

        DisableSecurityBypass = {
          InvalidCertificate = false;
          SafeBrowsing = false;
        }; 

        HardwareAcceleration = true;
        #RequestedLocales = [ "de-DE" "en-US" ];

        PrintingEnabled = true;

        EncryptedMediaExtensions = true;

        ExtensionSettings = {
          # Get Extension IDs about:debugging#/runtime/this-firefox
          "floccus@handmadeideas.org" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/floccus/latest.xpi";
          };
          "keepassxc-browser@keepassxc.org" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          };
          "plasma-browser-integration@kde.org" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
          };
          "languagetool-webextension@languagetool.org" = { # set domain to https://languagetool.m4rx.cc/v2/
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
          };
          "addon@simplelogin" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/simplelogin/latest.xpi";
          };
          "{b11bea1f-a888-4332-8d8a-cec2be7d24b9}" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/torproject-snowflake/latest.xpi";
          };
          "uBlock0@raymondhill.net" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
          #"CanvasBlocker@kkapsner.de" = { # set if privacy.resistFingerprinting = false or webgl.disabled = false
          #  "installation_mode" = "force_installed";
          #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
          #};
          "idcac-pub@guus.ninja" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
          };
          "addon@darkreader.org" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          };

          "uBlock0@raymondhill.net".adminSettings = {
            userSettings = rec {
              advancedUserEnabled = true;
              uiTheme = "auto";
              uiAccentCustom = true;
              uiAccentCustom0 = "#8839ef";
              cloudStorageEnabled = false;
              importedLists = [
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              ];
              externalLists = lib.concatStringsSep "\n" importedLists;
              popupPanelSections = 63;
              tooltipsDisabled = true;
            };
            selectedFilterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "adguard-spyware"
              "easyprivacy"
              "urlhaus-1"
              "plowe-0"
              "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            ];
          };

          "keepassxc-browser@keepassxc.org".adminSettings = {
            settings = {
              autoReconnect = true;
              afterFillSorting = "sortByMatchingCredentials";
              afterFillSortingTotp = "sortByRelevantEntry";
              autoCompleteUsernames = true;
              showGroupNameInAutocomplete = true;
              autoFillAndSend = false;
              autoFillSingleEntry = false;
              autoFillSingleTotp = true;
              autoRetrieveCredentials = true;
              autoSubmit = true;
              checkUpdateKeePassXC = 0;
              clearCredentialsTimeout = 10;
              colorTheme = "system";
              credentialSorting = "sortByGroupAndTitle";
              defaultGroupAlwaysAsk = true;
              downloadFaviconAfterSave = true;
              passkeys = true;
              passkeysFallback = true;
              saveDomainOnly = true;
              showGettingStartedGuideAlert = true;
              showTroubleshootingGuideAlert = true;
              showLoginFormIcon = true;
              showLoginNotifications = true;
              showNotifications = true;
              useMonochromeToolbarIcon = false;
              showOTPIcon = true;
              useObserver = true;
              usePredefinedSites = true;
              usePasswordGeneratorIcons = false;
            };
          };

          "{c49b13b1-5dee-4345-925e-0c793377e3fa}".adminSettings = {
            settings = {
              enable_automatic_theater_mode = true;
              enable_automatically_disable_ambient_mode = true;
              enable_automatically_disable_closed_captions = true;
              enable_automatically_set_quality = true;
              enable_default_to_original_audio_track = true;
              enable_hide_artificial_intelligence_summary = true;
              enable_hide_paid_promotion_banner = true;
              enable_hide_playlist_recommendations_from_home_page = true;
              enable_hide_shorts = true;
              enable_hide_translate_comment = true;
              enable_pausing_background_players = false;
              enable_redirect_remover = true;
              enable_remaining_time = true;
              enable_timestamp_peek = true;
              enable_video_history = true;
              player_quality = "4k";
            };
          };
          
          settings = {
            isApplied = true;
            autoUpdate = 1;
            updateEnabledScriptsOnly = false;
            exportValues = true;
            closeAfterInstall = false;
            editAfterInstall = false;
            autoReload = true;
            importScriptData = true;
            importSettings = true;
            notifyUpdates = false;
            notifyUpdatesGlobal = false;
            defaultInjectInto = "auto";
            showAdvanced = true;
          };
        };
      };

      profiles = {
        default = {
          id = 0;
          isDefault = true;
          settings = customization;
          search = {
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "channel"; value = "unstable"; }
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                definedAliases = [ "@np" ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              };

              "Nix Options" = {
                urls = [{
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "channel"; value = "unstable"; }
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                definedAliases = [ "@no" ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              };

              "Home Manager Options" = {
                urls = [{
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                definedAliases = [ "@hm" ];
                icon = "https://icons.duckduckgo.com/ip3/home-manager-options.extranix.com.ico";
              };

              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
                icon = "https://nixos.wiki/favicon.png";
              };

              "SearXNG" = {
                urls = [{ template = "https://searxng.m4rx.cc/search/{searchTerms}"; }];
                definedAliases = [ "@s" ];
                icon = "https://searxng.m4rx.cc/favicon";
              };

              "ddg" = {
                urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
                definedAliases = [ "@d" ];
                icon = "https://icons.duckduckgo.com/ip3/duckduckgo.com.ico";
              };

              "Brave" = {
                urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
                definedAliases = [ "@b" ];
                icon = "https://icons.duckduckgo.com/ip3/search.brave.com.ico";
              };

              "qwant" = {
                urls = [{ template = "https://www.qwant.com/?q={searchTerms}"; }];
                definedAliases = [ "@q" ];
                icon = "https://icons.duckduckgo.com/ip3/www.qwant.com.ico";
              };

              "Startpage" = {
                urls = [{ template = "https://www.startpage.com/sp/search?q={searchTerms}"; }];
                definedAliases = [ "@sp" ];
                icon = "https://www.startpage.com/sp/cdn/favicons/favicon--default.ico";
              };
            };

            order = [
              "Suck-O-Mat"
              "ddg"
              "Brave"
              "qwant"
              "Startpage"
              "Nix Packages"
              "Nix Options"
              "Home Manager Options"
              "NixOS Wiki"
            ];

            default = "ddg";
            privateDefault = "ddg";
          };
        };
      };
    };
  };
}
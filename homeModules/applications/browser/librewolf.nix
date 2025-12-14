{ config, lib, pkgs, ... }:

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
      package = (pkgs.wrapLibrewolf (pkgs.librewolf-unwrapped.override { 
        pipewireSupport = true;
        alsaSupport = true;
        }) {});

      nativeMessagingHosts = with pkgs; [
        kdePackages.plasma-browser-integration
      ];

      settings = {
        "webgl.disabled" = false;
        "browser.profiles.enabled" = true;
        "cookiebanners.service.mode" = 2;
      };

      policies = {
        DefaultDownloadDirectory = "\${home}/Downloads";

        #DontCheckDefaultBrowser = true;
        #EnterprisePoliciesEnabled = true;

        #DisableFeedbackCommands = true;
        #DisableFirefoxAccounts = true;
        #DisableFirefoxStudies = true;
        #DisableFormHistory = true;
        #DisablePocket = true;
        #DisableSafeMode = true;
        #DisableSetDesktopBackground = true;
        #NoDefaultBookmarks = lib.mkDefault true;

        #DisableSecurityBypass = {
        #  InvalidCertificate = false;
        #  SafeBrowsing = false;
        #}; 

        #DisableTelemetry = true;
        #DNSOverHTTPS = "Enabled";

        #EnableTrackingProtection = {
        #  Value = true;
        #  Locked = true;
        #  Cryptomining = true;
        #  Fingerprinting = true;
        #  EmailTracking = true;
        #  Exceptions = [ ];
        #};
        
        #FirefoxHome = {
        #  Search = true;
        #  TopSites = false;
        #  SponsoredTopSites = false;
        #  Highlights = false;
        #  Pocket = false;
        #  SponsoredPocket = false;
        #  Snippets = false;
        #  Locked = true;
        #};

        #GoToIntranetSiteForSingleWordEntryInAddressBar = false;
        #HardwareAcceleration = true;
        #PasswordManagerEnabled = false;
        #PrimaryPassword = false;
        #RequestedLocales = [ "de-DE" "en-US" ];

        #PrintingEnabled = true;

        #EncryptedMediaExtensions = true;

        #UserMessaging = {
        #  WhatsNew = false;
        #  ExtensionRecommendations = false;
        #  FeatureRecommendations = false;
        #  UrlbarInterventions = false;
        #  SkipOnboarding = true;
        #  MoreFromMozilla = false;
        #};

        #FirefoxSuggest = {
        #  WebSuggestions = false;
        #  SponsoredSuggestions = false;
        #  ImproveSuggest = false;
        #  Locked = true;
        #};

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
          "addon@simplelogin" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/simplelogin/latest.xpi";
          };
          "{b11bea1f-a888-4332-8d8a-cec2be7d24b9}" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/torproject-snowflake/latest.xpi";
          };
          #"uBlock0@raymondhill.net" = {
          #  "installation_mode" = "force_installed";
          #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          #};
          "{c49b13b1-5dee-4345-925e-0c793377e3fa}" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/youtube_enhancer_vc/latest.xpi";
          };
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
              player_quality = "hd1440";
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

        #SearchEngines = {
        #  #Add = [];
        #  Remove = [
        #    "Google"
        #    "Bing"
        #    "Amazon.de"
        #    #"DuckDuckGo"
        #    "eBay"
        #    "Ecosia"
        #    "LEO Eng-Deu"
        #    "Wikipedia (en)"
        #  ];
        #  Default = "ddg";
        #};

        #Handlers = {};
      };

      profiles = {
        default = {
          id = 0;
          isDefault = true;
          #settings = arkenfox-js;
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

              "Such-O-Mat" = {
                urls = [{ template = "https://searxng.m4rx.cc/search/{searchTerms}"; }];
                definedAliases = [ "@s" ];
                icon = "https://searxng.m4rx.cc/favicon";
              };

              "ddg" = {
                urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
                #params = [
                #    { name = "q"; value = "{searchTerms}"; }
                #  ];
                definedAliases = [ "@d" ];
                icon = "https://icons.duckduckgo.com/ip3/duckduckgo.com.ico";
              };

              "Brave" = {
                urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
                #params = [
                #    { name = "q"; value = "{searchTerms}"; }
                #  ];
                definedAliases = [ "@b" ];
                icon = "https://icons.duckduckgo.com/ip3/search.brave.com.ico";
              };

              "qwant" = {
                urls = [{ template = "https://www.qwant.com/?q={searchTerms}"; }];
                #params = [
                #    { name = "q"; value = "{searchTerms}"; }
                #  ];
                definedAliases = [ "@q" ];
                icon = "https://icons.duckduckgo.com/ip3/www.qwant.com.ico";
              };

              "Startpage" = {
                urls = [{ template = "https://www.startpage.com/sp/search?q={searchTerms}"; }];
                #params = [
                #    { name = "query"; value = "{searchTerms}"; }
                #  ];
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

        work = {
          id = 1;
          settings = lib.mkMerge [
            {
              "privacy.sanitize.sanitizeOnShutdown" = lib.mkDefault false;
            }
          ];
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Teams";
                tags = [ "teams" ];
                keyword = "teams";
                url = "https://teams.microsoft.com";
              }
            ];
          };
        };
        
        school = {
          id = 2;
          settings = lib.mkMerge [
            {
              "privacy.sanitize.sanitizeOnShutdown" = lib.mkDefault false;
            }
          ];
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Teams";
                tags = [ "teams" ];
                keyword = "teams";
                url = "https://teams.microsoft.com";
              }
              {
                name = "WebUntis";
                tags = [ "untis" ];
                keyword = "untis";
                url = "https://webuntis.com";
              }
            ];
          };
        };
        
        entertainment = {
          id = 3;
          settings = lib.mkMerge [
            {
              "privacy.sanitize.sanitizeOnShutdown" = lib.mkDefault false;
            }
          ];
          bookmarks = {
            force = true;
            settings = [
              {
                name = "YouTube";
                tags = [ "youtube" ];
                keyword = "youtube";
                url = "https://youtube.com/";
              }
              {
                name = "Netflix";
                tags = [ "netflix" ];
                keyword = "netflix";
                url = "https://netflix.com/de";
              }
              {
                name = "Disney";
                tags = [ "disney" ];
                keyword = "disney";
                url = "https://www.disneyplus.com";
              }
              {
                name = "Twitch";
                tags = [ "twitch" ];
                keyword = "twitch";
                url = "https://twitch.tv";
              }
            ];
          };
        };

        privacy = {
          id = 4;
          containersForce = true;
        };

        pwatemplate = {
          id = 9;
          containersForce = true;
          settings = arkenfox-js;
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

              "Such-O-Mat" = {
                urls = [{ template = "https://searxng.m4rx.cc/search/{searchTerms}"; }];
                definedAliases = [ "@s" ];
                icon = "https://searxng.m4rx.cc/favicon";
              };

              "ddg" = {
                urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
                #params = [
                #    { name = "q"; value = "{searchTerms}"; }
                #  ];
                definedAliases = [ "@d" ];
                icon = "https://icons.duckduckgo.com/ip3/duckduckgo.com.ico";
              };

              "Brave" = {
                urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
                #params = [
                #    { name = "q"; value = "{searchTerms}"; }
                #  ];
                definedAliases = [ "@b" ];
                icon = "https://icons.duckduckgo.com/ip3/search.brave.com.ico";
              };

              "qwant" = {
                urls = [{ template = "https://www.qwant.com/?q={searchTerms}"; }];
                #params = [
                #    { name = "q"; value = "{searchTerms}"; }
                #  ];
                definedAliases = [ "@q" ];
                icon = "https://icons.duckduckgo.com/ip3/www.qwant.com.ico";
              };

              "Startpage" = {
                urls = [{ template = "https://www.startpage.com/sp/search?q={searchTerms}"; }];
                #params = [
                #    { name = "query"; value = "{searchTerms}"; }
                #  ];
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
{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    userEnvironment.chromium-policies = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable chromium-policies.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.chromium-policies.enable {
    programs.chromium = {
      enable = true;

      extensions = [
        "cimiefiiaegbelhefglklhhakcgmhkai"
        "edibdbjcniadpccecjdfdjjppcpchdlm"
        "fnaicdffflnofjppbagibeoednhnbjhg"
        "oboonakemofpalcgghocfoadofidjkkk"
        "dphilobhebphkdjbpfohgikllaljmgbn"
        "mafpmfcccpbjnhfhjnllmmalhifmlcie"
      ];

      #initialPrefs = { };

      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;

        "MetricsReportingEnabled" = false;
        "SafeBrowsingExtendedReportingEnabled" = false;
        "BraveP3AEnabled" = false;
        "BraveStatsPingEnabled" = false;

        "TranslateEnabled" = false;
        "BookmarkBarEnabled" = true;
        "ShowFullUrlsInAddressBar" = true;
        "RestoreOnStartup" = 5;
        "PromptForDownloadLocation" = true;
        "DefaultDownloadDirectory" = config.home-manager.users.${userName}.xdg.userDirs.download;
        "BackgroundModeEnabled" = false;
        "HttpsOnlyMode" = "force_enabled";
        "DnsOverHttpsMode" = "automatic";
        "OsColorMode" = "auto";

        "AutofillCreditCardEnabled" = false;
        "AutofillAddressEnabled" = false;
        "PasswordManagerEnabled" = false;

        "SpellcheckLanguage" = [
          "de"
          "en-US"
        ];

        "PrivacySandboxAdTopicsEnabled" = false;
        "PrivacySandboxSiteEnabledAdsEnabled" = false;
        "PrivacySandboxAdMeasurementEnabled" = false;
        "PrivacySandboxFirstPartySetsEnabled" = false;

        "ExtensionManifestV2Availability" = 2;

        "PromotionsEnabled" = false;
        "TorDisabled" = true;
        "BraveWalletDisabled" = true;
        "BraveRewardsDisabled" = true;
        "BraveVPNDisabled" = true;
        "BraveAIChatEnabled" = false;
        "BraveNewsDisabled" = true;
        "BraveTalkDisabled" = true;
        "BraveSpeedreaderEnabled" = false;
        "BraveWaybackMachineEnabled" = false;
        "BraveWebDiscoveryEnabled" = false;

        "BraveShieldsAdBlockLevel" = 2;
        "BraveShieldsTrackerBlockLevel" = 2;
        "BraveShieldsFingerprintingBlockLevel" = 1;

        "ClearBrowsingDataOnExitList" = [
          "browsing_history"
          "download_history"
          "cookies_and_other_site_data"
          "cached_images_and_files"
          "password_signin"
          "site_settings"
        ];

        "3rdparty" = {
          extensions = {
            "oboonakemofpalcgghocfoadofidjkkk" = {
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
          };
        };
      };
    };
  };
}

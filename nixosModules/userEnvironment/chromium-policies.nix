{
  config,
  lib,
  pkgs,
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
      enablePlasmaBrowserIntegration = true;

      extensions = [
        "cimiefiiaegbelhefglklhhakcgmhkai" # Plasma Integration
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
        "fnaicdffflnofjppbagibeoednhnbjhg" # floccus bookmark sync
        "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC-Browser
        "dphilobhebphkdjbpfohgikllaljmgbn" # SimpleLogin
        "mafpmfcccpbjnhfhjnllmmalhifmlcie" # Snowflake
      ];

      #initialPrefs = { };

      extraOpts = {
        # ── Chromium-Cor: Login & Sync ───────────────────────────────
        "BrowserSignin" = 0;
        "SyncDisabled" = true;

        # ── Telemetry & Reporting ────────────────────────────────────
        "MetricsReportingEnabled" = false;
        "SafeBrowsingExtendedReportingEnabled" = false;
        "BraveP3AEnabled" = false;
        "BraveStatsPingEnabled" = false;

        # ── UI & Behavior ────────────────────────────────────────────
        "TranslateEnabled" = false;
        "BookmarkBarEnabled" = true;
        "ShowFullUrlsInAddressBar" = true;
        "RestoreOnStartup" = 5; # Neue Tab-Seite
        "PromptForDownloadLocation" = true;
        "DefaultDownloadDirectory" = "/mount/Data/Datein/Downloads";
        "BackgroundModeEnabled" = false;
        "OsColorMode" = "auto";
        #"BrowserThemeColor" = ;

        # ── Autofill & Passwords ─────────────────────────────────────
        "AutofillCreditCardEnabled" = false;
        "AutofillAddressEnabled" = false;
        "PasswordManagerEnabled" = false;

        # ── Language & Spellchecking ─────────────────────────────────
        "SpellcheckLanguage" = [
          "de"
          "en-US"
        ];

        # ── Privacy Sandbox ───────────────────────────────────────────
        "PrivacySandboxAdTopicsEnabled" = false;
        "PrivacySandboxSiteEnabledAdsEnabled" = false;
        "PrivacySandboxAdMeasurementEnabled" = false;
        "PrivacySandboxFirstPartySetsEnabled" = false;

        # ── Manifest V2 ─────────────────────────────────────────
        "ExtensionManifestV2Availability" = 2;

        # ── Brave: Deactivate Bloatware ─────────────────────────────
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

        # ── Brave Shields: aggressive ──────────────────────────────────
        "BraveShieldsAdBlockLevel" = 2;
        "BraveShieldsTrackerBlockLevel" = 2;
        "BraveShieldsFingerprintingBlockLevel" = 1;

        # ── Remove Date on Close ────────────────────────────────
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
              adminSettings = {
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

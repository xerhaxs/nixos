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

      extraOpts = {
        # ── Chromium-Kern: Login & Sync ───────────────────────────────
        "BrowserSignin" = 0;
        "SyncDisabled" = true;

        # ── Telemetrie & Reporting ────────────────────────────────────
        "MetricsReportingEnabled" = false;
        "SafeBrowsingExtendedReportingEnabled" = false;

        # ── UI & Verhalten ────────────────────────────────────────────
        "TranslateEnabled" = false;
        "BookmarkBarEnabled" = true;
        "ShowFullUrlsInAddressBar" = true;
        "RestoreOnStartup" = 5; # Neue Tab-Seite
        "PromptForDownloadLocation" = false;
        "DefaultDownloadDirectory" = "/mount/Data/Datein/Downloads";

        # ── Autofill & Passwörter ─────────────────────────────────────
        "AutofillCreditCardEnabled" = false;
        "AutofillAddressEnabled" = false;
        "PasswordManagerEnabled" = false;

        # ── Sprache & Rechtschreibung ─────────────────────────────────
        "SpellcheckLanguage" = [
          "de"
          "en-US"
        ];

        # ── Privacy Sandbox ───────────────────────────────────────────
        "PrivacySandboxAdTopicsEnabled" = false;
        "PrivacySandboxSiteEnabledAdsEnabled" = false;
        "PrivacySandboxAdMeasurementEnabled" = false;
        "PrivacySandboxFirstPartySetsEnabled" = false;

        # ── MV2 aktiv halten ─────────────────────────────────────────
        "ExtensionManifestV2Availability" = 2;

        # ── Brave: Bloatware deaktivieren ─────────────────────────────
        "BraveWalletDisabled" = true;
        "BraveRewardsDisabled" = true;
        "BraveVPNDisabled" = true;
        "BraveAIChatEnabled" = false;
        "BraveNewsDisabled" = true;
        "BraveTalkDisabled" = true;
        "BraveWaybackMachineDisabled" = true;

        # ── Brave Shields: aggressiv ──────────────────────────────────
        "BraveShieldsAdBlockLevel" = 2;
        "BraveShieldsTrackerBlockLevel" = 2;
        "BraveShieldsFingerprintingBlockLevel" = 1;

        # ── Daten beim Beenden löschen ────────────────────────────────
        "ClearBrowsingDataOnExitList" = [
          "browsing_history"
          "download_history"
          "cookies_and_other_site_data"
          "cached_images_and_files"
          "password_signin"
          "site_settings"
        ];
      };
    };
  };
}

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
      homepageLocation = "https://glance.m4rx.cc/";
      #defaultSearchProviderSuggestURL = "";
      #defaultSearchProviderSearchURL = "";
      defaultSearchProviderEnabled = true;

      extensions = [
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
        "fnaicdffflnofjppbagibeoednhnbjhg" # floccus bookmark sync
        "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC browser
        "dphilobhebphkdjbpfohgikbnghngdbk" # SimpleLogin
        "mafpmfcccpbjnhfhjnllmmalhifmlcie" # Snowflake (Tor)
      ];

      extraOpts = {
        # ── Chromium-Standardrichtlinien ──────────────────────────────

        # Kein Google-Login, keine Sync
        "BrowserSignin" = 0;
        "SyncDisabled" = true;

        # Kein Chromium-Telemetrie (zusätzlich zu Brave-eigenem P3A)
        "MetricsReportingEnabled" = false;

        # SafeBrowsing: Brave hat eigene Implementierung, Standard reicht
        "SafeBrowsingEnabled" = true;
        "SafeBrowsingExtendedReportingEnabled" = false; # kein Reporting an Google

        # DNS-over-HTTPS erzwingen (Brave nutzt eigene DoH-Logik,
        # aber als Fallback sinnvoll)
        "DnsOverHttpsMode" = "automatic";

        # Kein Google-Translate-Ping
        "TranslateEnabled" = false;

        # Kein Autofill für Zahlungsdaten / Adressen
        "AutofillCreditCardEnabled" = false;
        "AutofillAddressEnabled" = false;

        # Passwortmanager deaktivieren (KeePassXC übernimmt das)
        "PasswordManagerEnabled" = false;

        # MV2 aktiv halten (für eventuelle MV2-Extensions)
        "ExtensionManifestV2Availability" = 2;

        # ── Brave-eigene Policies ──────────────────────────────────────

        # Crypto/Web3-Bloatware deaktivieren
        "BraveWalletDisabled" = true;
        "BraveRewardsDisabled" = true;
        "BraveVPNDisabled" = true;

        # Leo AI deaktivieren
        "BraveAIChatEnabled" = false;

        # Brave News (Sponsored content auf New Tab Page) deaktivieren
        "BraveNewsDisabled" = true;

        # Brave Talk (Video-Calls) deaktivieren
        "BraveTalkDisabled" = true;

        # Wayback Machine Integration deaktivieren
        "BraveWaybackMachineDisabled" = true;

        # Shields: Tracking & Ads aggressiv blocken (systemweite Policy)
        # 1 = Standard, 2 = Aggressiv
        "BraveShieldsAdBlockLevel" = 2;
        "BraveShieldsTrackerBlockLevel" = 2;

        # Fingerprinting-Schutz aktivieren
        "BraveShieldsFingerprintingBlockLevel" = 1;
      };

      # Initiale Einstellungen (vom Nutzer änderbar, nur Defaults)
      initialPrefs = {
        "brave" = {
          "shields_defaults" = {
            "ad_control_type" = 2; # aggressiv
            "cookie_control_type" = 1; # Cross-Site-Cookies blockieren
            "fingerprinting_control_type" = 1;
            "https_upgrade" = true;
          };
        };
        "browser" = {
          "show_home_button" = true;
        };
      };
    };
  };
}

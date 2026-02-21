{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.communication.thunderbird = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Thunderbird.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.thunderbird.enable {
    programs.thunderbird = {
      enable = true;

      profiles = {
        "default" = {
          isDefault = true;

          settings = {
            # === Setup Mail Accounts ===
            "mail.accountmanager.accounts" = "account1,account3,account4,account2";

            # === General UI and behavior settings ===
            "intl.locale.requested" = "de-DE"; # UI language
            "spellchecker.dictionary" = "de-DE"; # Spellcheck language
            "intl.regional_prefs.use_os_locales" = true; # Don't use OS locale
            "intl.regional_prefs.locales" = "de-DE"; # Use metric etc.

            "mailnews.default_sort_type" = 18; # Sort by date
            "mailnews.default_sort_order" = 2; # Newest first
            "mailnews.default_news_sort_type" = 18;
            "mailnews.default_news_sort_order" = 2;

            "mail.thread_structures_with_ids" = false; # No message grouping
            "mail.ui.tableView" = false; # table view
            "mailnews.default_view_flags" = 0;

            "mail.folder.views.version" = 1; # Folder pane view
            "mail.ui.folderpane.expand_state" = "All"; # Expand all folders

            "mail.SpellCheckBeforeSend" = true; # Check before sending
            "mail.spellcheck.inline" = true; # Inline spellcheck

            "mail.tabs.drawInTitlebar" = false; # No tabs in title bar
            "mail.tabs.autoHide" = false; # Always show tabs

            "privacy.donottrackheader.enabled" = true;
            "network.cookie.cookieBehavior" = 2;

            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "browser.ping-centre.telemetry" = false;

            "browser.search.defaultenginename" = "DuckDuckGo";
            "browser.search.selectedEngine" = "DuckDuckGo";

            "mail.biff.play_sound" = false;
            "mail.chat.play_sound" = false;

            "offline.download.download_messages" = 1;
            "offline.startup_state" = 4;

            "ldap_2.autoComplete.useDirectory" = true;

            "mail.e2ee.auto_enable" = true;
            "mail.e2ee.auto_disable" = true;

            ## Optional user-agent override
            "general.useragent.override" = "";

            "thunderbird.policies.runOncePerModification.extensionsInstall" =
              "https://addons.thunderbird.net/thunderbird/downloads/latest/grammar-and-spell-checker/latest/latest.xpi,https://addons.thunderbird.net/thunderbird/downloads/latest/german-dictionary-de_de-for-sp/latest/latest.xpi,https://addons.thunderbird.net/thunderbird/downloads/latest/filelink-nextcloud-owncloud/latest/latest.xpi,https://addons.thunderbird.net/thunderbird/downloads/latest/cardbook/latest/latest.xpi";
          };

          #extraConfig = ''
          #  lockPref("extensions.autoDisableScopes", 0);
          #'';
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  site = osConfig.nixos.site;

  # Changes only the display name. The account id comes from the attribute name, a new name would
  # create a new account in Thunderbird.
  showAddress = address: id: { "mail.server.server_${id}.name" = address; };

  # Addresses come from the private site data, an account without address does not exist here.
  mkAccount =
    name: server:
    lib.mkIf (site.mailAccounts ? ${name}) (
      lib.recursiveUpdate server rec {
        address = site.mailAccounts.${name}.address or "";
        userName = address;
        realName = site.mailAccounts.${name}.realName or site.mailRealName;
        thunderbird = {
          enable = true;
          profiles = [ "default" ];
          settings = showAddress address;
        };
      }
    );

  accountOrder =
    lib.filter (name: site.mailAccounts ? ${name}) [
      "proton"
    ]
    ++ lib.optional (site.mailAddress != null) "stalwart"
    ++ lib.filter (name: site.mailAccounts ? ${name}) [
      "dlrg"
      "oneandone"
    ];
in

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
          withExternalGnupg = true;
          accountsOrder = accountOrder;

          settings = {
            "mailnews.start_page.enabled" = false;
            "mailnews.start_page.url" = "";

            "intl.locale.requested" = "de-DE";
            "spellchecker.dictionary" = "de-DE";
            "intl.regional_prefs.use_os_locales" = true;
            "intl.regional_prefs.locales" = "de-DE";

            "mailnews.default_sort_type" = 18;
            "mailnews.default_sort_order" = 2;
            "mailnews.default_news_sort_type" = 18;
            "mailnews.default_news_sort_order" = 2;

            "mail.thread_structures_with_ids" = false;
            "mail.ui.tableView" = true;
            "mailnews.default_view_flags" = 0;

            "mail.folder.views.version" = 1;
            "mail.ui.folderpane.expand_state" = "All";

            "mail.SpellCheckBeforeSend" = true;
            "mail.spellcheck.inline" = true;

            "mail.tabs.drawInTitlebar" = false;
            "mail.tabs.autoHide" = false;

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

            "mailnews.headers.sendUserAgent" = false;
            "mail.smtpserver.default.hello_argument" = "[127.0.0.1]";

            "mailnews.display.html_as" = 3;
            "javascript.enabled" = false;

            "mailnews.reply_header_type" = 1;

            "thunderbird.policies.runOncePerModification.extensionsInstall" =
              "https://addons.thunderbird.net/thunderbird/downloads/latest/grammar-and-spell-checker/latest/latest.xpi,https://addons.thunderbird.net/thunderbird/downloads/latest/german-dictionary-de_de-for-sp/latest/latest.xpi,https://addons.thunderbird.net/thunderbird/downloads/latest/cardbook/latest/latest.xpi";
          };

          #extraConfig = ''
        };
      };
    };

    # Proton Mail Bridge on this machine, the password comes from the bridge (protonmail-bridge --cli, info).
    accounts.email.accounts.proton = mkAccount "proton" {
      primary = true;
      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
    };

    accounts.email.accounts.dlrg = mkAccount "dlrg" {
      imap = {
        host = "mail.dlrg.de";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.dlrg.de";
        port = 465;
        tls.enable = true;
      };
    };

    accounts.email.accounts.oneandone = mkAccount "oneandone" {
      imap = {
        host = "imap.1und1.de";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.1und1.de";
        port = 465;
        tls.enable = true;
      };
    };

    accounts.email.accounts.stalwart = lib.mkIf (osConfig.nixos.site.mailAddress != null) {
      primary = !(site.mailAccounts ? proton);
      address = osConfig.nixos.site.mailAddress;
      userName = osConfig.nixos.site.mailAddress;
      realName = osConfig.nixos.site.mailRealName;
      imap = {
        host = "mail.${osConfig.nixos.site.mailDomain}";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.${osConfig.nixos.site.mailDomain}";
        port = 465;
        tls.enable = true;
      };
      gpg = lib.mkIf (osConfig.nixos.site.pgpFingerprint != null) {
        key = osConfig.nixos.site.pgpFingerprint;
        signByDefault = true;
        encryptByDefault = false;
      };
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
        settings = showAddress osConfig.nixos.site.mailAddress;
      };
    };

    # Stalwart serves CalDAV/CardDAV for the same account (default collections).
    accounts.calendar.accounts = lib.mkIf (osConfig.nixos.site.mailAddress != null) {
      ${osConfig.nixos.site.mailAddress} = {
        remote = {
          type = "caldav";
          url = "https://mail.${osConfig.nixos.site.mailDomain}/dav/cal/${osConfig.nixos.site.mailAddress}/default/";
          userName = osConfig.nixos.site.mailAddress;
        };
        thunderbird = {
          enable = true;
          profiles = [ "default" ];
        };
      };
    };

    accounts.contact.accounts = lib.mkIf (osConfig.nixos.site.mailAddress != null) {
      ${osConfig.nixos.site.mailAddress} = {
        remote = {
          type = "carddav";
          url = "https://mail.${osConfig.nixos.site.mailDomain}/dav/card/${osConfig.nixos.site.mailAddress}/default/";
          userName = osConfig.nixos.site.mailAddress;
        };
        thunderbird = {
          enable = true;
          profiles = [ "default" ];
        };
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".thunderbird"
      ];
    };
  };
}

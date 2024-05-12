{ config, lib, pkgs, ... }:

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

      settings = {
        #"general.useragent.override" = "";
        "mail.tabs.drawInTitlebar" = false;
        "mail.tabs.autoHide" = false;
        "mail.biff.play_sound" = false;
        "mail.chat.play_sound" = false;
        "privacy.donottrackheader.enabled" = true;
        "offline.download.download_messages" = 1;
        "offline.startup_state" = 4;
        "mail.SpellCheckBeforeSend" = true;
        "mail.spellcheck.inline" = true;
        "ldap_2.autoComplete.useDirectory" = true;
        "thunderbird.policies.runOncePerModification.extensionsInstall" = "https://addons.thunderbird.net/thunderbird/downloads/latest/german-dictionary-de_de-for-sp/addon-9361-latest.xpi,https://addons.thunderbird.net/thunderbird/downloads/latest/filelink-nextcloud-owncloud/addon-987761-latest.xpi";
        "network.cookie.cookieBehavior" = 2;
        "mail.spam.manualMark" = true;
        "datareporting.healthreport.uploadEnabled" = false;
        "mail.e2ee.auto_enable" = true;
        "mail.e2ee.auto_disable" = true;
      };

      profiles = {
        "default" = {
          isDefault = true;
        };
      };
    };

    accounts.email = {
      maildirBasePath = "${config.xdg.userDirs.documents}/Mails";
    };
  };
}

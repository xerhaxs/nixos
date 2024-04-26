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
        "privacy.donottrackheader.enabled" = true;
      };

      profiles = {
        "jf" = {
          isDefault = true;
          name = "jf";
          settings = {
            "mail.spellcheck.inline" = true;
          };
        };
      };
    };

    #accounts.email = {
    #  maildirBasePath = "${config.xdg.userDirs.documents}/Mails";
    #  accounts = {
    #    "mail@mail.com" = {
    #      userName = "mail@mail.com";
    #      address = "mail@mail.com";
    #      aliases = [
    #        mail@mail.com
    #        mail@mail.com
    #      ];
    #      folders = {
    #        drafts = "Drafts";
    #        #inbox = "";
    #        sent = "Sent";
    #        #trash = "";
    #      };
    #    };
    #  };
    #};
  };
}

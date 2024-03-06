{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    settings = {

    };

    profiles = {
      "mail@mail.com" = {
        isDefault = true;
        settigns = {
          "mail.spellcheck.inline" = true;
        };
      };

      "mail2@mail.com" = {
        isDefault = false;
        settigns = {
          "mail.spellcheck.inline" = true;
        };
      };
    };
  };

  accounts.email = {
    maildirBasePath = "${config.xdg.userDirs.documents}/Mails";
    accounts = {
      "mail@mail.com" = {
        userName = "mail@mail.com";
        address = "mail@mail.com";
        aliases = [
          mail@mail.com
          mail@mail.com
        ];
        folders = {
          drafts = "Drafts";
          #inbox = "";
          sent = "Sent";
          #trash = "";
        };
      };
    };
  };
}

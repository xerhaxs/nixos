{ config, pkgs, ... }:

environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
  };

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

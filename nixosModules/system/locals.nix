{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.locals = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable system locals.";
      };
      lang = {
        type = types.str;
        default = "en_US.UTF-8";
      };
      local = {
        type = types.str;
        default = "de_DE.UTF-8"
      };
      timezone = {
        type = types.str;
        default = "Europe/Berlin";
      };
      consolekbd = {
        type = types.str;
        default = "de";
      };
    };
  };

  time.timeZone = "${config.nixos.system.locals.timezone}";

  i18n.defaultLocale = "${config.nixos.system.locals.lang}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${config.nixos.system.locals.local}";
    LC_IDENTIFICATION = "${config.nixos.system.locals.local}";
    LC_MEASUREMENT = "${config.nixos.system.locals.local}";
    LC_MONETARY = "${config.nixos.system.locals.local}";
    LC_NAME = "${config.nixos.system.locals.local}";
    LC_NUMERIC = "${config.nixos.system.locals.local}";
    LC_PAPER = "${config.nixos.system.locals.local}";
    LC_TELEPHONE = "${config.nixos.system.locals.local}";
    LC_TIME = "${config.nixos.system.locals.local}";
  };

  console.keyMap = "${config.nixos.system.locals.consolekbd}";

  services.xserver = {
    xkb.layout = "${config.nixos.system.locals.consolekbd}";
    xkb.variant = "";
    #xkb.options = "";
  };
}

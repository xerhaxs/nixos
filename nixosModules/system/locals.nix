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
        type = lib.types.str;
        default = "en_US.UTF-8";
      };
      local = {
        type = lib.types.str;
        default = "de_DE.UTF-8";
      };
      timezone = {
        type = lib.types.str;
        default = "Europe/Berlin";
      };
      consolekbd = {
        type = lib.types.str;
        default = "de";
      };
    };
  };

  config = {
    timezone = {
      time.timeZone = "${config.nixos.system.locals.timezone}";
    };

    lang = {
      i18n.defaultLocale = "${config.nixos.system.locals.lang}";
    };

    local = {
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
    };

    consolekbd = {
      console.keyMap = "${config.nixos.system.locals.consolekbd}";
      services.xserver = {
        xkb.layout = "${config.nixos.system.locals.consolekbd}";
        xkb.variant = "";
        #xkb.options = "";
      };
    };
  };
}

{ config, lib, pkgs, ... }:

let
  lang = "en_US.UTF-8";
  local = "de_DE.UTF-8";
  timezone = "Europe/Berlin";
  consolekbd = "de";
in

{
  time.timeZone = "${timezone}";

  i18n.defaultLocale = "${lang}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${local}";
    LC_IDENTIFICATION = "${local}";
    LC_MEASUREMENT = "${local}";
    LC_MONETARY = "${local}";
    LC_NAME = "${local}";
    LC_NUMERIC = "${local}";
    LC_PAPER = "${local}";
    LC_TELEPHONE = "${local}";
    LC_TIME = "${local}";
  };

  console.keyMap = "${consolekbd}";

  services.xserver = {
    xkb.layout = "${consolekbd}";
    xkb.variant = "";
    #xkb.options = "";
  };
}

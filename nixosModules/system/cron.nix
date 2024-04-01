{ config, pkgs, ... }:

{
  services.cron = {
    enable = true;
  };
}

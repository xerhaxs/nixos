{ config, lib, pkgs, ... }:

{
  nixos.server.enable = lib.mkForce true;

  nixos.server = {
    home = {
      #mailserver.enable = lib.mkForce false;
      etesync.enable = lib.mkForce false;
      haos.enable = lib.mkForce false;
      homeassistant.enable = lib.mkForce false;
    };
    network = {
      adguard.enable = lib.mkForce false;
    };
    fediverse = {
      peertube.enable = lib.mkForce false;
      pixelfed.enable = lib.mkForce false;
      mastodon.enable =lib.mkForce false;
      lemmy.enable = lib.mkForce false;
    };
  };
}
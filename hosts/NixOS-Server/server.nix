{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  #nixos.server.network.nginx.enable = true;

  #nixos.server.home.jellyfin.enable = true;

  #nixos.server.home.nextcloud.enable = true;

  networking.firewall.enable = lib.mkForce false; # only for testing purpos

  #nixos.server.enable = lib.mkDefault true;

  #nixos.server.usenet.enable = false;

  #nixos.server = {
  #  home = {
  #    #mailserver.enable = lib.mkForce false;
  #    etesync.enable = lib.mkForce false;
  #    haos.enable = lib.mkForce false;
  #    homeassistant.enable = lib.mkForce false;
  #  };
  #  network = {
  #    adguard.enable = lib.mkForce false;
  #  };
  #  fediverse = {
  #    peertube.enable = lib.mkForce false;
  #    pixelfed.enable = lib.mkForce false;
  #    mastodon.enable =lib.mkForce false;
  #    lemmy.enable = lib.mkForce false;
  #  };
  #};
}
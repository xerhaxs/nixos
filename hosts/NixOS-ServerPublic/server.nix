{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx = {
    enable = true;
    challenge = "http-01";
  };

  nixos.server.game.minecraft.enable = true;

  nixos.system.nasmount.enable = lib.mkForce false;

  nixos.system.mount.enable = lib.mkForce false;

  nixos.disko.enable = lib.mkForce false;

  nixos.system.sops.enable = lib.mkForce false;

  services.openssh = {
    #allowSFTP = true;
    settings = {
      PasswordAuthentication = lib.mkForce false;
    };
  };
}
{ config, lib, pkgs, ... }:

{
  homeManager.applications.enable = lib.mkForce true;
  homeManager.desktop.enable = lib.mkForce false;
}
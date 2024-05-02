{ config, lib, pkgs, ... }:

{
  homeManager.applications.enable = lib.mkForce false;
}
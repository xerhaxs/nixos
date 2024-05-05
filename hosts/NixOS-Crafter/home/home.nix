{ config, lib, pkgs, ... }:

{
  homeManager.applications.enable = lib.mkDefault true;
}
{ config, lib, pkgs, ... }:

{
  programs.discocss = {
    enable = true;
    discordAlias = true;
    discordPackage = pkgs.webcord;
  };
}

{ config, lib, pkgs, ... }:

{
  services.upower = {
    enable = true;
  };
}

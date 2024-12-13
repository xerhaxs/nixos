{ config, lib, pkgs, ... }:

{
  services.fprintd.enable = true;

  services.displayManager = {
    sddm = {
      wayland.enable = lib.mkForce false;
    };
  };
}
{ config, pkgs, ... }:

{
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #home-manager.packages."${pkgs.system}".home-manager
  ];
}

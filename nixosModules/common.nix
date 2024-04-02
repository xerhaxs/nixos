{ config, pkgs, ... }:

{
  

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    newt # whiptail package for nixos
    gparted
    sbctl # for secureboot
    ntfs3g # support for windows file systems
    nix-output-monitor # nix related
    nix-prefetch
    nixos-generators
    #home-manager.packages."${pkgs.system}".home-manager
  ];

  programs.vim.defaultEditor = true;
  programs.htop.enable = true;
}

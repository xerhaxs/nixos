{ config, pkgs, osConfig, ... }:

{
  imports = [
    ./shell

    #./alacritty.nix
    ./common.nix
    ./dconf.nix
    #./emacs.nix
    ./fonts.nix
    ./git.nix
    ./java.nix
    ./kitty.nix
    #./neovim.nix
    ./tex.nix
    ./vim.nix
    ./xdg.nix
    ./xresources.nix
  ];

  home.username = "${osConfig.defaultuser.name}";
  home.homeDirectory = "/home/" + osConfig.defaultuser.name;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}

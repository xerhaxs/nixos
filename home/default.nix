{ config, pkgs, ... }:

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
}

{ config, pkgs, ... }:

{
  imports = [
    ../../../home

    ../../../home-modules/3dprinting.nix
    ../../../home-modules/applications.nix
    ../../../home-modules/editing.nix
    #../../../home-modules/gnome
    ../../../home-modules/hyprland
    #../../../home-modules/firefox.nix
    ../../../home-modules/flameshot.nix
    ../../../home-modules/hacking.nix
    ../../../home-modules/kdeconnect.nix
    ../../../home-modules/librewolf.nix
    ../../../home-modules/multimedia.nix
    ../../../home-modules/obs-studio.nix
    ../../../home-modules/office.nix
    ../../../home-modules/plasma5.nix
    ../../../home-modules/privacy.nix
    ../../../home-modules/programming.nix
    ../../../home-modules/syncthing.nix
    ../../../home-modules/theme-latte.nix
    #../../../home-modules/thunderbird.nix
    ../../../home-modules/vscodium.nix

    ./hyprland.nix
    ./xdg.nix
  ];

  home.username = "jf";
  home.homeDirectory = "/home/jf";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';  # set cursor size and dpi for 4k monitor



  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

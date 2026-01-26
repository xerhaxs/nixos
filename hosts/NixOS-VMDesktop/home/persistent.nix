{ config, lib, impermanence, pkgs, ... }:

{
  home.persistence."/persistent" = {
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
      { directory = ".nixops"; mode = "0700"; }
      { directory = ".local/share/keyrings"; mode = "0700"; }
      ".local/share/direnv"
      ".local/share/baloo"
      ".local/share/bottles"
      ".local/share/PrismLauncher" # Create Symlink from Game Drive via HomeManager
      ".local/share/wasistlos" # WhatsApp
      ".local/share/Steam"
      ".local/share/TelegramDesktop"
      ".librewolf"
      ".mozilla"
      ".steam"
      ".thunderbird"
      ".wine"
      ".local/cache"
      #".local/state" # move file settings to nixos
    ];
    files = [
      ".bash_history" # Bash History
      ".viminfo" # VIM History
    ];
  };
}
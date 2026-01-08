{ config, lib, impermanence, osConfig, pkgs, ... }:

{
  home.persistence = {
    directories = [
      #"Desktop"
      #"Documents"
      #"Downloads"
      #"Music"
      #"Pictures"
      #"Videos"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".local/share/baloo"
      ".local/share/bottles"
      ".local/share/PrismLauncher" # Create Symlink from Game Drive via HomeManager
      ".local/share/wasistlos" # WhatsApp
      ".local/share/TelegramDesktop"
      ".librewolf"
      ".mozilla"
      ".steam"
      ".thunderbird"
      ".wine"
      ".local/cache"
      ".local/state" # move file settings to nixos
      #{
      #  directory = ".local/share/Steam";
      #  method = "symlink";
      #}
    ];
    files = [
      ".bash_history" # Bash History
      ".viminfo" # VIM History

    ];
  };
}
{
  config,
  lib,
  impermanence,
  pkgs,
  ...
}:

{
  home.persistence."/persistent" = {
    directories = [
      ".aqbanking"
      ".cache"
      
      ".thunderbird"
      ".librewolf"
      ".mozilla"

      ".steam"
      
      ".tor project"
      #".winboat"
      #".wine"

      "${config.home.homeDirectory}/Desktop"
      "${config.home.homeDirectory}/Dokumente"
      "${config.home.homeDirectory}/Downloads"
      "${config.home.homeDirectory}/Musik"
      "${config.home.homeDirectory}/Bilder"
      "${config.home.homeDirectory}/Videos"

      ".config/backintime"
      ".config/Element"
      ".config/FreeTube"
      #".config/heroic"
      #".config/kdeconnect"
      ".config/legcord"
      ".config/"
      #".config"
      #".local"

      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".cert";
        mode = "0700";
      }
      {
        directory = ".pki";
        mode = "0700";
      }
    ];
    files = [
      ".bash_history"
      ".viminfo"
    ];
  };
}

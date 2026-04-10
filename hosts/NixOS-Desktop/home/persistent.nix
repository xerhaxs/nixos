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
      ".librewolf"
      ".mozilla"
      ".steam"
      ".thunderbird"
      ".tor project"
      #".winboat"
      #".wine"

      #"Documents"
      #"Pictures"
      #"Downloads"
      #"Videos"
      #"Music"

      ".config"
      ".local"
      ".local/share/steam"
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
    files = [
      ".bash_history"
      ".viminfo"
    ];
  };
}

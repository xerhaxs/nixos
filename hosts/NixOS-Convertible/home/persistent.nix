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

      ".steam"
      
      ".tor project"
      #".winboat"
      #".wine"

      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"

      ".config/BraveSoftware"
      ".config/Clementine"
      ".config/Element"
      ".config/FreeTube"
      #".config/heroic"
      ".config/kdeconnect"
      ".config/kmymoney"
      ".config/legcord"
      #".config/libreoffice"
      ".config/Mullvad VPN"
      #".config/Mumble"
      ".config/obs-studio"
      #".config/Proton"
      #".config/Proton Mail"
      ".config/Signal"
      ".config/sops"
      #".config/steamtinkerlaunch"
      ".config/VSCodium"

      ".local/cache"

      ".local/state"

      ".local/share/backintime"
      ".local/share/baloo"
      #".local/share/Bisq2"
      #".local/share/bottles"
      ".local/share/dolphin"
      ".local/share/gwenview"
      ".local/share/kdenlive"
      ".local/share/klipper"
      ".local/share/kmymoney"
      ".local/share/Mumble"
      ".local/share/okular"
      ".local/share/plasma_notes"
      ".local/share/protonmail"
      ".local/share/qalculate"
      ".local/share/ranger"
      #".local/share/Steam"
      ".local/share/TelegramDesktop"
      #".local/share/wasistlos"
      #".local/share/whatsapp-for-linux"

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

      ".config/Clementinerc"
      ".config/kilerc"
    ];
  };
}

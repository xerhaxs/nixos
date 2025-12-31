{ config, lib, impermanence, osConfig, pkgs, ... }:

{
  imports = [
    impermanence.homeManagerModules.impermanence
  ];

  home.persistence."/persistent/home/${osConfig.nixos.system.user.defaultuser.name}" = {
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
      #{
      #  directory = ".local/share/Steam";
      #  method = "symlink";
      #}
    ];
    #files = [
    #  ".screenrc"
    #];
    allowOther = true;
  };
}
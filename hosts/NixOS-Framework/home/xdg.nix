{
  config,
  lib,
  pkgs,
  ...
}:

{
  xdg.userDirs = {
    setSessionVariables = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Dokumente";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Musik";
    pictures = "${config.home.homeDirectory}/Bilder";
    videos = "${config.home.homeDirectory}/Videos";
  };
}

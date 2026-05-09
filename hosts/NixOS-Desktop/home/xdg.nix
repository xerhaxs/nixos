{
  config,
  lib,
  pkgs,
  ...
}:

{
  xdg.userDirs = {
    setSessionVariables = true;
    desktop = "/mount/Data/Datein/Desktop";
    documents = "/mount/Data/Datein/Dokumente";
    download = "/mount/Data/Datein/Downloads";
    music = "/mount/Data/Datein/Musik";
    pictures = "/mount/Data/Datein/Bilder";
    videos = "/mount/Data/Datein/Videos";
    extraConfig = {
      GAMES = "/mount/Games/Spiele";
    };
  };

  home.file = {
    "Desktop".source = config.lib.file.mkOutOfStoreSymlink config.xdg.userDirs.desktop;
    "Documents".source = config.lib.file.mkOutOfStoreSymlink config.xdg.userDirs.documents;
    "Downloads".source = config.lib.file.mkOutOfStoreSymlink config.xdg.userDirs.download;
    "Music".source = config.lib.file.mkOutOfStoreSymlink config.xdg.userDirs.music;
    "Pictures".source = config.lib.file.mkOutOfStoreSymlink config.xdg.userDirs.pictures;
    "Videos".source = config.lib.file.mkOutOfStoreSymlink config.xdg.userDirs.videos;
  };
}

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

  # Direct symlinks (systemd-tmpfiles), not home.file: mkOutOfStoreSymlink leads through the Nix
  # store, and Nix refuses such a path for the flake input private (~/Documents/nixos-private,
  # "path '//home/jf/Documents' is a symlink").
  systemd.user.tmpfiles.rules = lib.mapAttrsToList (link: target: "L+ %h/${link} - - - - ${target}") {
    Desktop = config.xdg.userDirs.desktop;
    Documents = config.xdg.userDirs.documents;
    Downloads = config.xdg.userDirs.download;
    Music = config.xdg.userDirs.music;
    Pictures = config.xdg.userDirs.pictures;
    Videos = config.xdg.userDirs.videos;
  };
}

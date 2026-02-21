{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.syncthing = {
    settings = {
      folders = {
        # "sendreceive", "sendonly", "receiveonly", "receiveencrypted"
        "Desktop" = {
          path = "/mount/pool01/share/jf/desktop";
        };
        "Documents" = {
          path = "/mount/pool01/share/jf/documents";
        };
        "Downloads" = {
          path = "/mount/pool01/share/jf/download";
        };
        "Music" = {
          path = "/mount/pool01/share/jf/music";
        };
        "Pictures" = {
          path = "/mount/pool01/share/jf/pictures";
        };
        "Videos" = {
          path = "/mount/pool01/share/jf/videos";
        };
      };
    };
  };
}

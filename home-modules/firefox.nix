{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
#    settings = {
#      "webgl.disabled" = true;
#      "network.http.referer.XOriginPolicy" = 2;
#      "media.autoplay.blocking_policy" = 2;
#      "security.OCSP.require" = false;
#    };
  };
}

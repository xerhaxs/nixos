{ config, pkgs, ... }:

{
  services.uptime-kuma = {
    enable = true;
    appriseSupport = true;
    settings = {
      HOST = "uptime-kuma.bitsync.icu";
      PORT = "8765";
    };
  };
}

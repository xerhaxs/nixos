{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.home-assistant.config = {
    switch = [
      {
        platform = "sony_projector";
        host = "10.75.0.97";
        name = "SonyBeamer";
      }
    ];

    media_player = [
      {
        platform = "panasonic_bluray";
        host = "10.75.0.60";
        name = "UHD Player";
      }
    ];
  };

  services.openthread-border-router = {
    enable = true;
    backboneInterfaces = [ "eno1" ];
    openFirewall = false;
    radio = {
      device = "/dev/serial/by-id/usb-Nabu_Casa_Home_Assistant_Connect_ZBT-1_3ca08035a338ef11b2653a7af3d9b1e5-if00-port0";
      baudRate = 460800;
      flowControl = true;
    };
    rest = {
      listenAddress = "::";
      listenPort = 8081;
    };
  };
}

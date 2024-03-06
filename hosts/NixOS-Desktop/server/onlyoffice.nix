{ config, lib, pkgs, ... }:

{
  services.onlyoffice = {
    enable = true;
    hostname = "onlyoffice.bitsync.icu";
    enableExampleServer = true;
    jwtSecretFile = null;
    examplePort = 8000;
    port = 8000;
  };

  networking.enableIPv6 = lib.mkForce true;
}

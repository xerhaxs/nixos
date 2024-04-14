{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.onlyoffice = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Onlyoffice.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.onlyoffice.enable {
    services.onlyoffice = {
      enable = true;
      hostname = "onlyoffice.bitsync.icu";
      enableExampleServer = true;
      jwtSecretFile = null;
      examplePort = 8000;
      port = 8000;
    };

    networking.enableIPv6 = lib.mkForce true;
  };
}

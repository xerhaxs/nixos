{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fediverse
    ./fileshare
    ./game
    ./home
    ./network
    ./usenet
  ];

  options.nixos = {
    server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable server modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.enable {
    nixos.server = {
      fediverse.enable = true;
      #fileshare.enable = true;
      game.enable = lib.mkDefault false;
      home.enable = true;
      network.enable = true;
      usenet.enable = true;
    };
  };
}

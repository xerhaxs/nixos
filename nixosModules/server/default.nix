{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./entertainment
    ./fileshare
    ./game
    ./management
    ./network
    ./public
    ./sync
    ./tools
  ];

  options.nixos = {
    server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable server modules bundle.";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib";
        example = "/pool01/applications";
        description = "Base directory for the state of server applications (<dataDir>/<service>).";
      };
    };
  };

  config = lib.mkIf config.nixos.server.enable {
    nixos.server = {
      entertainment.enable = true;
      fileshare.enable = true;
      game.enable = lib.mkDefault false;
      management.enable = true;
      network.enable = true;
      public.enable = lib.mkDefault false;
      sync.enable = true;
      tools.enable = true;
    };
  };
}

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

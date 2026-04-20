{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./cryptpad.nix
    ./matrix.nix
    ./murmur.nix
    ./stalwart.nix
  ];

  options.nixos = {
    server.public = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable public modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.enable {
    nixos.server.public = {
      cryptpad.enable = true;
      matrix.enable = true;
      murmur.enable = true;
      stalwart.enable = true;
    };
  };
}

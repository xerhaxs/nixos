{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./nginx.nix
    ./pihole.nix
    ./unbound.nix
  ];

  options.nixos = {
    server.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable network modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.enable {
    nixos.server.network = {
      nginx.enable = true;
      pihole.enable = true;
      unbound.enable = true;
    };
  };
}

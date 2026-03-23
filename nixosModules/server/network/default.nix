{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./mullvad-server.nix
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
      mullvad-server.enable = true;
      nginx.enable = true;
      pihole.enable = true;
      unbound.enable = true;
    };
  };
}

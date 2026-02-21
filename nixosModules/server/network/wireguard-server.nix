{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.network.wireguard-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable wireguard server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.wireguard-server.enable {

  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./forgejo.nix
    ./linkwarden.nix
    ./radicale.nix
  ];

  options.nixos = {
    server.sync = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable sync modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.sync.enable {
    nixos.server.sync = {
      forgejo.enable = true;
      linkwarden.enable = true;
      radicale.enable = true;
    };
  };
}

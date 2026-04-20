{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./cockpit.nix
    ./glance.nix
    ./homeassistant.nix
  ];

  options.nixos = {
    server.management = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable management modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.management.enable {
    nixos.server.management = {
      cockpit.enable = true;
      glance.enable = true;
      homeassistant.enable = true;
    };
  };
}

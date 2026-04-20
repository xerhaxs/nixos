{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./cockpit.nix
    ./cryptpad.nix
    ./glance.nix
    ./homeassistant.nix
    ./jellyfin.nix
    ./networkingtoolbox.nix
    ./ollama.nix
    ./radicale.nix
    ./stalwart.nix
  ];

  options.nixos = {
    server.home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.enable {
    nixos.server.home = {
      cockpit.enable = true;
      cryptpad.enable = true;
      glance.enable = true;
      homeassistant.enable = true;
      jellyfin.enable = true;
      networkingtoolbox.enable = true;
      ollama.enable = true;
      radicale.enable = true;
      stalwart.enable = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./config
    ./game
    ./io

    ./appimage.nix
    ./chromium-policies.nix
    ./fonts.nix
    ./kdeconnect.nix
    ./networkshares.nix
    ./syncthing.nix
  ];

  options.nixos = {
    userEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable userEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.enable {
    nixos.userEnvironment = {
      config.enable = true;
      game.enable = true;
      io.enable = true;

      appimage.enable = true;
      chromium-policies.enable = true;
      fonts.enable = true;
      kdeconnect.enable = true;
      networkshares.enable = true;
      syncthing.enable = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./game
    ./io

    ./appimage.nix
    ./chromium-policies.nix
    ./fonts.nix
    ./kdeconnect.nix
    ./mullvad.nix
    ./networkshares.nix
    ./obs-studio.nix
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
      game.enable = true;
      io.enable = true;

      appimage.enable = true;
      chromium-policies.enable = true;
      fonts.enable = true;
      kdeconnect.enable = true;
      mullvad.enable = true;
      networkshares.enable = true;
      obs-studio.enable = true;
      syncthing.enable = true;
    };
  };
}

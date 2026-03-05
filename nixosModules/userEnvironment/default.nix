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
    ./fonts.nix
    ./kdeconnect.nix
    ./mullvad.nix
    ./samba-client.nix
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
      game.enable = lib.mkDefault false;
      io.enable = true;

      appimage.enable = true;
      fonts.enable = true;
      kdeconnect.enable = true;
      mullvad.enable = true;
      samba-client.enable = true;
      syncthing.enable = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./briar-mailbox.nix
    ./collabora.nix
    ./coturn.nix
    ./cryptpad.nix
    ./matrix.nix
    ./miniflux.nix
    ./mollysocket.nix
    ./nextcloud.nix
    ./ntfy.nix
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
      briar-mailbox.enable = lib.mkDefault true;
      collabora.enable = lib.mkDefault true;
      coturn.enable = lib.mkDefault true;
      cryptpad.enable = lib.mkDefault true;
      matrix.enable = lib.mkDefault true;
      miniflux.enable = lib.mkDefault true;
      mollysocket.enable = lib.mkDefault false;
      nextcloud.enable = lib.mkDefault true;
      ntfy.enable = lib.mkDefault true;
      stalwart.enable = lib.mkDefault true;
    };
  };
}

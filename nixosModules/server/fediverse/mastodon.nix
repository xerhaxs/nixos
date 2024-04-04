{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.mastodon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Mastodon.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.mastodon.enable {
    services.mastodon = {
      enable = true;
    };
  };
}

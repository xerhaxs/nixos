{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.libreddit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Libreddit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.libreddit.enable {
    services.redlib = {
      enable = true;
      address = "127.0.0.1";
      port = 8975;
      openFirewall = false;
    };
  };
}

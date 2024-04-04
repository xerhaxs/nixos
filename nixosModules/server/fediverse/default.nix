{ config, lib, pkgs, ... }:

{ 
  options.nixos = {
    server.fediverse = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable fediverse modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.enable {
    imports = [
      ./freshrss.nix
      ./gitea.nix
      ./invidious.nix
      ./lemmy.nix
      ./libreddit.nix
      ./mastodon.nix
      ./moneronode.nix
      ./nitter.nix
      ./peertube.nix
      ./pixelfed.nix
      ./searxng.nix
    ];
  };
}

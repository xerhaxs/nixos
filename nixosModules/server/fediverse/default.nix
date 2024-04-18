{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./freshrss.nix
    ./gitea.nix
    ./invidious.nix
    ./lemmy.nix
    ./libreddit.nix
    ./mastodon.nix
    ./moneronode.nix
    ./murmur.nix
    ./nitter.nix
    ./peertube.nix
    ./pixelfed.nix
    ./searxng.nix
    ./teamspeak.nix
  ];

  options.nixos = {
    server.fediverse = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fediverse modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.enable {
    nixos.server.fediverse = {
      freshrss.enable = true;
      gitea.enable = true;
      invidious.enable = true;
      lemmy.enable = true;
      libreddit.enable = true;
      mastodon.enable = true;
      moneronode.enable = true;
      murmur.enable = true;
      nitter.enable = true;
      peertube.enable = true;
      pixelfed.enable = true;
      searxng.enable = true;
      teamspeak.enable = true;
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

{ 
  options.nixos = {
    server.fediverse = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable fediverse modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.server.fediverse.enable {
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

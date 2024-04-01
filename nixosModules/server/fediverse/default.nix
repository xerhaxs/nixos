{ pkgs, lib, config, ... }: 

{ 
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
}

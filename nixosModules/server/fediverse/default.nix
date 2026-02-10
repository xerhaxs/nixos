{ config, lib, pkgs, ... }:

{ 
  imports = [
    ./gitea.nix
    ./invidious.nix
    ./languagetool.nix
    ./libreddit.nix
    ./matrix.nix
    ./moneronode.nix
    ./murmur.nix
    ./nitter.nix
    ./searxng.nix
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
      gitea.enable = true;
      invidious.enable = true;
      languagetool.enable = true;
      libreddit.enable = true;
      matrix.enable = true;
      moneronode.enable = true;
      murmur.enable = true;
      nitter.enable = true;
      searxng.enable = true;
    };
  };
}

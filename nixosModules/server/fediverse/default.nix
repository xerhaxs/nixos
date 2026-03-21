{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./forgejo.nix
    ./invidious.nix
    ./kiwix.nix
    ./languagetool.nix
    ./libreddit.nix
    ./matrix.nix
    ./moneronode.nix
    ./murmur.nix
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
      forgejo.enable = true;
      invidious.enable = true;
      kiwix.enable = true;
      languagetool.enable = true;
      libreddit.enable = true;
      matrix.enable = true;
      moneronode.enable = true;
      murmur.enable = true;
      searxng.enable = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./invidious.nix
    ./kiwix.nix
    ./languagetool.nix
    ./libreddit.nix
    ./libretranslate.nix
    ./moneronode.nix
    ./networkingtoolbox.nix
    ./ollama.nix
    ./searxng.nix
  ];

  options.nixos = {
    server.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.tools.enable {
    nixos.server.tools = {
      invidious.enable = true;
      kiwix.enable = true;
      languagetool.enable = true;
      libreddit.enable = true;
      libretranslate.enable = true;
      moneronode.enable = true;
      networkingtoolbox.enable = true;
      ollama.enable = true;
      searxng.enable = true;
    };
  };
}

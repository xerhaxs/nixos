{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bash.nix
    ./btop.nix
    ./git.nix
    ./secrets.nix
    ./ranger.nix
    ./starship.nix
  ];

  options.homeManager = {
    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable base modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.enable {
    homeManager.base = {
      bash.enable = true;
      btop.enable = true;
      git.enable = true;
      secrets.enable = true;
      ranger.enable = true;
      starship.enable = true;
    };
  };
}

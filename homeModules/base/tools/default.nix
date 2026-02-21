{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./backup.nix
    ./btop.nix
    ./git.nix
    ./ranger.nix
  ];

  options.homeManager = {
    base.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.enable {
    homeManager.base.tools = {
      backup.enable = true;
      btop.enable = true;
      git.enable = true;
      ranger.enable = true;
    };
  };
}

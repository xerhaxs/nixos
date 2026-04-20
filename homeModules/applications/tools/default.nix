{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./backintime.nix
    ./gnomedisk.nix
    ./git.nix
    ./keepassxc.nix
    ./qalculate.nix
  ];

  options.homeManager = {
    applications.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable tools modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.enable {
    homeManager.applications.tools = {
      backintime.enable = true;
      gnomedisk.enable = true;
      keepassxc.enable = true;
      qalculate.enable = true;
    };
  };
}

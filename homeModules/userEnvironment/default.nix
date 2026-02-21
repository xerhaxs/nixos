{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fonts.nix
    ./sessionVariables.nix
  ];

  options.homeManager = {
    userEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable userEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.userEnvironment.enable {
    homeManager.userEnvironment = {
      fonts.enable = true;
      sessionVariables.enable = true;
    };
  };
}

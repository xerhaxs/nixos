{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.ranger = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ranger.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.ranger.enable {
    programs.ranger = {
      enable = true;
      #settings = { };
      #plugins = [ ];
    };
  };
}

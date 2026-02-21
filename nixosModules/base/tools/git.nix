{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.tools.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Git.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.git.enable {
    programs.git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "master";
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.tools.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable git.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "xerhaxs";
          email = "github.wjtpq@slmail.me";
        };
      };
    };

    home.packages = with pkgs; [
      bfg-repo-cleaner
      gh
    ];
  };
}

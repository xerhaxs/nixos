{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.java = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Java.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.java.enable {
    programs.java = {
      enable = true;
      package = pkgs.jdk;
    };
  };
}

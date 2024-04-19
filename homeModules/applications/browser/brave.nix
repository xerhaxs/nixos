{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.browser.brave = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Brave browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.brave.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };
  };
}
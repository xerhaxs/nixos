{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.office.joplin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable joplin desktop.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.joplin.enable {
    programs.joplin-desktop = {
      enable = true;
      general.editor = "kate";
      sync = {
        interval = "5m";
        target = "webdav";
      };
      #extraConfig = { };
    };
  };
}

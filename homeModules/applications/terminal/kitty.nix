{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.terminal.kitty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kitty.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;
      shellIntegration = {
        enableBashIntegration = true;
      };
      #environment = { };
      settings = {
        confirm_os_window_close = 0; # -1 not working, but this would be the better option
        shell_integration = "enabled";
      };
    };
  };
}

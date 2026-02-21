{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.browser.tor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Tor browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.tor.enable {
    home.packages = with pkgs; [
      tor-browser
    ];
  };
}

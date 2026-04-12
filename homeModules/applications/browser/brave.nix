{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.browser.brave = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable brave browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.brave.enable {
    programs.brave = {
      enable = true;
      package = pkgs.brave;

      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=WaylandWindowDecorations"
        "--force-webrtc-ip-handling-policy=disable_non_proxied_udp"
      ];
    };
  };
}

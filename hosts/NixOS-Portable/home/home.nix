{
  config,
  lib,
  pkgs,
  plasma-manager,
  ...
}:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  # Everything that exists, also the applications that are off by default elsewhere.
  homeManager.applications = {
    enable = true;
    development = {
      bottles.enable = true;
      diff.enable = true;
      hex.enable = true;
    };
    editing = {
      "3dprinting".enable = true;
      ai.enable = true;
      blender.enable = true;
    };
    education = {
      kiwix.enable = true;
      stellarium.enable = true;
    };
    gaming = {
      gameconqueror.enable = true;
      lutris.enable = false; # needs gtk2, which nixpkgs marks as broken, see TODO 13.20
    };
    sync.rclone.enable = true;
    vpn.protonvpn.enable = true;
  };
}

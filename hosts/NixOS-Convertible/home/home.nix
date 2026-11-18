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

  programs.plasma = {
    workspace = {
      wallpaper = lib.mkForce "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/54644815047_f6aaedf588_o.jpg";
    };
  };

  homeManager.applications.enable = true;

  # Rnote only here (pen).
  homeManager.desktop.favoritesExclude = [
    # Laptops: no virtual machines, recording or games on the task bar.
    "virt-manager"
    "com.obsproject.Studio"
    "org.prismlauncher.PrismLauncher"
    "com.heroicgameslauncher.hgl"
    "steam"
  ];
}

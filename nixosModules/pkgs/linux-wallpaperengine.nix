{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.linux-wallpaperengine.overrideAttrs (old: {
      installPhase = ''
        cp -r ${/mount/Games/Spiele/Steam/SteamLibrary/steamapps/common/wallpaper_engine/assets}/* $out/assets
        ${lib.optionalString (old ? installPhase) old.installPhase}
        mkdir -p $out/assets
        cp -r /mount/Games/Spiele/Steam/SteamLibrary/steamapps/common/wallpaper_engine/assets/* $out/assets/
      '';
    }))
  ];
}
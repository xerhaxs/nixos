{ config, lib, pkgs, ... }:

{
  # Erstelle ein derivation (Paket) für die linux-wallpaperengine mit kopierten Assets
  environment.systemPackages = [
    pkgs.stdenv.mkDerivation {
      pname = "linux-wallpaperengine";
      version = "unstable-2024-12-15";

      # Der Quellpfad zur Anwendung
      src = pkgs.fetchFromGitHub {
        owner = "Almamu";
        repo = "linux-wallpaperengine";
        rev = "version";
        sha256 = "";
      };

      # Der Pfad zu den Assets auf dem lokalen System
      localAssets = "/mount/Games/Spiele/Steam/SteamLibrary/steamapps/common/wallpaper_engine/assets";

      # Phase für die Installation
      installPhase = ''
        mkdir -p $out/bin
        cp -r $src/* $out/bin/

        # Kopiere die Assets in den Nix-Store
        mkdir -p $out/assets
        cp -r ${localAssets}/* $out/assets/
      '';

      # Metadaten
      meta = with pkgs.lib; {
        description = "Linux Wallpaper Engine with integrated assets from Steam";
        homepage = "https://github.com/your-repo";
        license = licenses.mit;
        maintainers = [ maintainers.yourName ];
      };
    }
  ];
}

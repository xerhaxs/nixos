{ config, lib, pkgs, ... }:

let
  version = "5.9.0";
  pname = "cura5";

  src = pkgs.fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    hash = "sha256-17h2wy2l9djzcinmnjmi2c7d2y661f6p1dqk97ay7cqrrrw5afs9"; # Hier die tatsächliche Hash-Wert einfügen, z.B. sha256.
  };

  meta = {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = "https://github.com/Ultimaker/Cura";
    downloadPage = "https://github.com/Ultimaker/Cura/releases";
    platforms = [ "x86_64-linux" ];
    mainProgram = "cura"; # Hauptprogramm für Exec in der Desktop-Datei definieren
  };

  appimageContents = appimageTools.extractType1 { inherit pname src meta; };
in

{
  
  pkgs.appimageTools.wrapType2 = {
    inherit pname version src;

    extraInstallCommands = ''
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';
  };
}

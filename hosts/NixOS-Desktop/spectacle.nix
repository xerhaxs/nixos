{ pkgs, lib, ... }:

let
  spectacleOverlay = self: super: {
    kdePackages = super.kdePackages // {
      spectacle = super.kdePackages.spectacle.overrideAttrs (oldAttrs: rec {
        nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [ super.makeWrapper ];
        postInstall = ''
          wrapProgram $out/bin/spectacle \
            --prefix PATH : ${
              super.tesseract5.override {
                enableLanguages = [
                  "eng"
                  "osd"
                  "deu"
                ];
              }
            }/bin \
            --set TESSDATA_PREFIX ${
              super.tesseract5.override {
                enableLanguages = [
                  "eng"
                  "osd"
                  "deu"
                ];
              }
            }/share/tessdata \
            --prefix LD_LIBRARY_PATH : ${
              super.tesseract5.override {
                enableLanguages = [
                  "eng"
                  "osd"
                  "deu"
                ];
              }
            }/lib
        '';
      });
    };
  };
in
{
  nixpkgs.overlays = [ spectacleOverlay ];
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.office.office = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable office tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.office.enable {
    home.packages = with pkgs; [
      cmark
      gImageReader
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_GB-large
      hunspellDicts.en_US
      hyphen
      kdePackages.ghostwriter
      languagetool
      libreoffice
      multimarkdown
      mythes
      pandoc
      poppler-utils
      rnote
      tesseract
      vcftools # vcf card management tool
      xournalpp
    ];
  };
}

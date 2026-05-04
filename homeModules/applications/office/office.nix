{
  config,
  lib,
  pkgs,
  osConfig,
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

    home.activation.libreofficeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      XCU="$HOME/.config/libreoffice/4/user/registrymodifications.xcu"
      if [ -f "$XCU" ]; then
        # Tooltips deaktivieren
        ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L \
          -u "//item[@oor:path='/org.openoffice.Office.Common/Help']/prop[@oor:name='ExtendedTip']/value" \
          -v "false" \
          "$XCU" 2>/dev/null || \
        ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L \
          -s "//oor:items" -t elem -n "item" \
          -i "//oor:items/item[last()]" -t attr -n "oor:path" -v "/org.openoffice.Office.Common/Help" \
          "$XCU"

        # LanguageTool aktivieren
        ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L \
          -u "//item[@oor:path='/org.openoffice.Office.Linguistic/GrammarChecking/LanguageTool']/prop[@oor:name='IsEnabled']/value" \
          -v "true" \
          "$XCU"

        # LanguageTool BaseURL
        ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L \
          -u "//item[@oor:path='/org.openoffice.Office.Linguistic/GrammarChecking/LanguageTool']/prop[@oor:name='BaseURL']/value" \
          -v "https://languagetool.m4rx.cc/v2/" \
          "$XCU"
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}

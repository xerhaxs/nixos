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
          ${pkgs.python3.withPackages (ps: [ ps.lxml ])}/bin/python3 << 'EOF'
      from lxml import etree
      import os

      xcu = os.path.expanduser("~/.config/libreoffice/4/user/registrymodifications.xcu")
      OOR = "http://openoffice.org/2001/registry"

      tree = etree.parse(xcu)
      root = tree.getroot()

      def ensure_item(path, name, value):
          for item in root:
              if item.get(f"{{{OOR}}}path") == path:
                  for prop in item:
                      if prop.get(f"{{{OOR}}}name") == name:
                          prop.find("value").text = value
                          return
          item = etree.SubElement(root, "item")
          item.set(f"{{{OOR}}}path", path)
          prop = etree.SubElement(item, "prop")
          prop.set(f"{{{OOR}}}name", name)
          prop.set(f"{{{OOR}}}op", "fuse")
          val = etree.SubElement(prop, "value")
          val.text = value

      ensure_item("/org.openoffice.Office.Common/Help",                             "ExtendedTip",        "false")
      ensure_item("/org.openoffice.Office.Linguistic/GrammarChecking/LanguageTool", "IsEnabled",          "true")
      ensure_item("/org.openoffice.Office.Linguistic/GrammarChecking/LanguageTool", "BaseURL",            "https://languagetool.m4rx.cc/v2/")
      ensure_item("/org.openoffice.Office.Linguistic/General",                      "DefaultLocale",      "de-DE")
      ensure_item("/org.openoffice.Office.Linguistic/General",                      "DefaultLocale_CJK",  "")
      ensure_item("/org.openoffice.Office.Linguistic/General",                      "DefaultLocale_CTL",  "")
      ensure_item("/org.openoffice.Setup/L10N",                                     "ooSetupSystemLocale","de-DE")
      ensure_item("/org.openoffice.Setup/L10N",                                     "DecimalSeparatorAsLocale", "true")

      tree.write(xcu, encoding="UTF-8", xml_declaration=True, pretty_print=True)
      EOF
        fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}

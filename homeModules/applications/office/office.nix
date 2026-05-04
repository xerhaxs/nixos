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
        ${pkgs.gnused}/bin/sed -i \
          's|<prop oor:name="ExtendedTip" oor:op="fuse"><value>true</value>|<prop oor:name="ExtendedTip" oor:op="fuse"><value>false</value>|g' \
          "$XCU"

        ${pkgs.gnused}/bin/sed -i \
          '/LanguageTool/{s|<prop oor:name="IsEnabled" oor:op="fuse"><value>false</value>|<prop oor:name="IsEnabled" oor:op="fuse"><value>true</value>|g}' \
          "$XCU"

        ${pkgs.gnused}/bin/sed -i \
          's|<prop oor:name="BaseURL" oor:op="fuse"><value>.*</value>|<prop oor:name="BaseURL" oor:op="fuse"><value>https://languagetool.m4rx.cc/v2/</value>|g' \
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

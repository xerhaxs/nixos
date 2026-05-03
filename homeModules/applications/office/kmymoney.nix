{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.office.kmymoney = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kmymoney";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.kmymoney.enable {
    home.packages = with pkgs; [
      aqbanking
      gwenhywfar
      kmymoney
    ];

    home.activation.kmymoneyAlphavantage = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        DEST="$HOME/.local/share/kmymoney/quotes/Alphavantage.co.txt"
        mkdir -p "$(dirname "$DEST")"
        API_KEY="$(cat ${osConfig.sops.secrets."alphavantage/api_key".path})"
        cat > "$DEST" << EOF
      date=day":\s"([\w-]+)"
      dateformat=yyyy-MM-dd
      defaultid=
      mode=HTML
      price=price":\s"([\d.]+)"
      sourceurl=https://store.kde.org/p/1291552/
      url=[https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=%1&apikey=](https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=%1&apikey=$API_KEY)$API_KEY
      EOF
    '';

    home.activation.kmymoneyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="$HOME/.config/kmymoney/kmymoneyrc"
      if [ ! -f "$CONFIG" ]; then
        mkdir -p "$(dirname "$CONFIG")"
        API_KEY="$(cat ${osConfig.sops.secrets."alphavantage/api_key".path})"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "List Options" --key "ShowAllAccounts"            "true"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "List Options" --key "ShowPlannedScheduleDates"   "true"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "List Options" --key "ShowRegisterDetailed"       "true"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "List Options" --key "logImportedStatements"      "false"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "List Options" --key "logOfxTransactions"         "false"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "List Options" --key "useSystemFont"              "true"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "DataFormat"            "1"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "DateFormatRegex"       "yyyy-MM-dd"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "DateRegex"             "day\":\\s\"([\\w-]+)\""
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "DefaultId"             ""
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "DownloadType"          "0"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "IDBy"                  "0"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "IDRegex"               ""
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "PriceDecimalSeparator" "0"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "PriceRegex"            "price\":\\s\"([\\d.]+)\""
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "ReferenceId"           ""
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "SkipStripping"         "true"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$CONFIG" \
          --group "Online-Quote-Source-Alphavantage.co.copy" --key "URL" \
          "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=%1&apikey=$API_KEY"
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".aqbanking"
        ".config/kmymoney"
        ".local/share/kmymoney"
      ];
    };
  };
}

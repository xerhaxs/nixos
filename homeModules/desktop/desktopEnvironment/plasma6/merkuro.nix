{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  cfg = config.homeManager.desktop.desktopEnvironment.plasma6.merkuro;

  # agentsrc and akonadiserverrc are QSettings files with backslashes in the keys, plasma-manager
  # would escape them. Adds the Radicale resource if missing and points Akonadi to the current
  # MariaDB (a stale store path after an update and garbage collection keeps Akonadi from starting).
  akonadiSetup = pkgs.writeShellScript "akonadi-radicale" ''
    set -eu -o pipefail
    PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.gawk
        pkgs.gnugrep
        pkgs.gnused
      ]
    }
    dir="$HOME/.config/akonadi"
    agents="$dir/agentsrc"
    firstrun="$HOME/.config/akonadi-firstrunrc"
    mkdir -p "$dir"
    [ -e "$agents" ] || printf '[InstanceCounters]\n\n[Instances]\n' > "$agents"

    # Adds key=value to the group unless the key exists. Writes through the file (cat, not mv), the
    # firstrun file is a symlink into the persistence.
    ensure() {
      local file="$1" group="$2" key="$3" value="$4"
      touch "$file"
      if grep -q -F -- "$key=" "$file"; then
        return 0
      fi
      if grep -q -F -x -- "[$group]" "$file"; then
        G="[$group]" L="$key=$value" awk '{ print } $0 == ENVIRON["G"] { print ENVIRON["L"] }' "$file" > "$file.tmp"
        cat "$file.tmp" > "$file"
        rm "$file.tmp"
      else
        printf '\n[%s]\n%s=%s\n' "$group" "$key" "$value" >> "$file"
      fi
    }
    # Only when there is no DAV resource yet (one added in Merkuro gets a higher number).
    if ! grep -q -E '^akonadi_davgroupware_resource_[0-9]+\\AgentType=' "$agents"; then
      ensure "$agents" InstanceCounters 'akonadi_davgroupware_resource\InstanceCounter' 1
      ensure "$agents" Instances 'akonadi_davgroupware_resource_0\AgentType' akonadi_davgroupware_resource
    fi

    # Only Radicale: mark the default birthday calendar, personal calendar and address book as
    # created, so Akonadi does not add them on a fresh home.
    ensure "$firstrun" ProcessedDefaults birthdaycalendar akonadi_birthdays_resource
    ensure "$firstrun" ProcessedDefaults defaultaddressbook akonadi_contacts_resource_0
    ensure "$firstrun" ProcessedDefaults defaultcalendar akonadi_ical_resource_0

    server="$dir/akonadiserverrc"
    if [ -e "$server" ]; then
      sed -i "s#^ServerPath=.*#ServerPath=${pkgs.mariadb.server}/bin/mariadbd#" "$server"
    fi
  '';
in

{
  options.homeManager = {
    desktop.desktopEnvironment.plasma6.merkuro = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Merkuro with the calendars and tasks of Radicale only (Akonadi DAV resource, CalDAV, complete history), events in the calendar of the clock; the password is asked once and kept in KWallet.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "https://radicale.${osConfig.nixos.site.homeDomain}/";
        defaultText = lib.literalExpression ''"https://radicale.''${osConfig.nixos.site.homeDomain}/"'';
        description = "CalDAV address of Radicale.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.plasma.configFile = {
      "akonadi_davgroupware_resource_0rc".General = {
        defaultUsername = config.home.username;
        displayName = "Radicale";
        # Retrieve all past events and tasks, not only the last 3 months.
        limitSyncRange = false;
        # CalDAV only: with CardDAV on the same URL both discoveries start at once, one of them goes out
        # without credentials, gets 401 and the resource drops the whole collection tree. Contacts are in
        # Thunderbird (CardBook).
        remoteUrls = "$default$|CalDav|${cfg.url}";
        settingsVersion = 3;
      };
      "akonadi/agent_config_akonadi_davgroupware_resource_0".Agent.Name = "Radicale";

      "defaultcalendarrc".General.ApplicationId = "org.kde.merkuro";
      "eventviewsrc".Timescale."24 Hour Clock" = true;
      "kalendarrc" = {
        GeneralView = {
          showSubtodosInCalendarViews = false;
          showTodosInCalendarViews = false;
        };
        MonthView = {
          showWeekNumbers = true;
          weekdayLabelAlignment = "Left";
        };
      };
      "plasma_calendar_holiday_regions".General.selectedRegions = "de_de";
    };

    # The clock keeps the calendars of its PIM events plugin (Akonadi collection ids) in plasmashellrc,
    # plasma-manager would delete the file on every activation.
    programs.plasma.resetFilesExclude = [ "plasmashellrc" ];

    home.activation.akonadiRadicale = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${akonadiSetup}
    '';

    # Files that existed before they were persisted would block the symlinks ("in the way"), move them
    # into the persistence once (the copy there wins if both exist).
    home.activation.akonadiPersistFiles = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable (
      lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        for f in .config/akonadi-firstrunrc .config/merkuro.calendarrc .config/plasmashellrc; do
          p="/persistent$HOME/$f"
          if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
            if [ -e "$p" ]; then
              run rm "$HOME/$f"
            else
              run mkdir -p "$(dirname "$p")"
              run mv "$HOME/$f" "$p"
            fi
          fi
          # KConfig cannot write through a symlink whose target does not exist.
          if [ ! -e "$p" ]; then
            run mkdir -p "$(dirname "$p")"
            run touch "$p"
          fi
        done
      ''
    );

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/akonadi"
        ".local/share/akonadi"
        ".local/share/akonadi-davgroupware"
      ];
      # Symlinks: KDE replaces these files by rename. The calendar selections of Merkuro and of the
      # clock refer to collection ids of the Akonadi database, firstrun keeps Akonadi from repeating
      # its migrations.
      files =
        map
          (file: {
            inherit file;
            method = "symlink";
          })
          [
            ".config/akonadi-firstrunrc"
            ".config/merkuro.calendarrc"
            ".config/plasmashellrc"
          ];
    };
  };
}

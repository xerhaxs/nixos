{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

let
  cfg = config.nixos.system.clamav;
  clamav = config.services.clamav;
  textfileDir = "/var/lib/prometheus-node-exporter";
  # Start of the last finished scan, files changed after it are scanned the next night.
  stamp = "/var/lib/clamav/last-scan";
  # Start of the last finished full scan.
  fullStamp = "/var/lib/clamav/last-full-scan";
  # Start of the last full scan, finished or not. A catch-up scan that keeps failing is retried weekly.
  fullAttempt = "/var/lib/clamav/last-full-attempt";
  # Open findings as JSON lines, a nightly scan only sees changed files and keeps the others.
  findings = "/var/lib/clamav/findings.jsonl";

  # Bash pattern for [[ == ]]: everything quoted except `*`.
  globPattern = glob: lib.concatStringsSep "*" (map lib.escapeShellArg (lib.splitString "*" glob));

  excludes = pkgs.writeText "clamav-excludes" (
    lib.concatStringsSep "\n" clamav.daemon.settings.ExcludePath + "\n"
  );

  # Daily only new and changed files (ctime, so copies with an old mtime count as well), a full scan
  # on cfg.fullScanDay, without a stamp or when the last one is older than 31 days. Summary and
  # findings go to the node exporter.
  scan = pkgs.writeShellApplication {
    name = "clamdscan-metrics";
    runtimeInputs = [
      clamav.package
      config.systemd.package
      pkgs.coreutils
      pkgs.findutils
      pkgs.gawk
      pkgs.gnugrep
      pkgs.gnused
      pkgs.jq
    ];
    text = ''
      out="$(mktemp)"
      list="$(mktemp)"
      found="$(mktemp)"
      open="$(mktemp)"
      trap 'rm -f "$out" "$list" "$found" "$open"' EXIT
      start=$(date +%s)
      touch "${stamp}.new"

      # Hosts without the full stamp (older versions of this script) start counting from the last scan.
      if [[ -e ${stamp} && ! -e ${fullStamp} ]]; then
        touch -r ${stamp} ${fullStamp}
      fi

      # Full scan: by hand, on the first run, on cfg.fullScanDay, or as catch-up for a host that was off
      # that day (last full scan older than 31 days, at most one attempt per week if it keeps failing).
      full=0
      if [[ ''${1:-} == full || ! -e ${stamp} || $(date +%-d) == ${toString cfg.fullScanDay} ]]; then
        full=1
      elif [[ -n $(find ${fullStamp} -mtime +31) ]] \
        && [[ ! -e ${fullAttempt} || -n $(find ${fullAttempt} -mtime +6) ]]; then
        full=1
      fi
      if (( full )); then
        touch ${fullAttempt}
      fi

      ${lib.optionalString (!cfg.onAccess.enable) ''
        # clamd only runs for the scan, it holds the signatures in RAM (up to 3 GB).
        # Recreate a lost socket file (removed together with /run/clamav before RuntimeDirectoryPreserve).
        if [[ ! -S ${clamav.daemon.settings.LocalSocket} ]]; then
          systemctl restart clamav-daemon.socket
        fi
        systemctl start clamav-daemon.service
        trap 'rm -f "$out" "$list" "$found" "$open"; systemctl stop clamav-daemon.service' EXIT
      ''}
      clamdscan --ping 60:5 > /dev/null

      set +e
      if (( full )); then
        clamdscan --multiscan --fdpass --infected --allmatch ${lib.escapeShellArgs clamav.scanner.scanDirectories} | tee "$out"
        rc=''${PIPESTATUS[0]}
        files=0
      else
        # NUL separated: file names may contain newlines, --file-list splits them.
        find ${lib.escapeShellArgs clamav.scanner.scanDirectories} -type f -cnewer ${stamp} -print0 2> /dev/null \
          | grep -z -E -v -f ${excludes} > "$list"
        files=$(tr -cd '\0' < "$list" | wc -c)
        rc=0
        if (( files > 0 )); then
          xargs -0 -r clamdscan --multiscan --fdpass --infected --allmatch < "$list" | tee "$out"
          # xargs only reports 123 for any failed batch, the summaries tell found (1) from error (2).
          (( PIPESTATUS[0] > 123 )) && rc=2
        fi
      fi
      set -e

      errors=$(sed -n 's/^Total errors: //p' "$out" | awk '{ n += $1 } END { print n + 0 }')
      if (( ! full && rc == 0 )); then
        if (( errors > 0 )); then
          rc=2
        elif grep -q ' FOUND$' "$out"; then
          rc=1
        fi
      fi

      { grep ' FOUND$' "$out" || true; } \
        | jq -R -c 'capture("^(?<path>.*): (?<signature>[^ ]+) FOUND$")' > "$found"
      # Keep earlier findings that still exist and were not rescanned (changed files are in this scan).
      if (( ! full )) && [[ -e ${findings} ]]; then
        while IFS= read -r entry; do
          path=$(jq -r .path <<< "$entry")
          if [[ -e $path && -z $(find "$path" -maxdepth 0 -cnewer ${stamp} 2> /dev/null) ]]; then
            printf '%s\n' "$entry"
          fi
        done < ${findings} >> "$found"
      fi
      sort -u "$found" > ${findings}.tmp
      mv ${findings}.tmp ${findings}

      # Findings checked by hand (cfg.acknowledged) leave the metrics.
      acknowledged=0
      ${
        if cfg.acknowledged == [ ] then
          ''
            cp ${findings} "$open"
          ''
        else
          ''
            : > "$open"
            while IFS= read -r entry; do
              path=$(jq -r .path <<< "$entry")
              signature=$(jq -r .signature <<< "$entry")
              known=0
              ${lib.concatMapStrings (a: ''
                if [[ $path == ${globPattern a.path} && $signature == ${globPattern a.signature} ]]; then known=1; fi
              '') cfg.acknowledged}
              if (( known )); then
                acknowledged=$(( acknowledged + 1 ))
              else
                printf '%s\n' "$entry" >> "$open"
              fi
            done < ${findings}
          ''
      }

      {
        echo "clamav_scan_infected_files $(wc -l < "$open")"
        echo "clamav_scan_acknowledged_files $acknowledged"
        echo "clamav_scan_errors $errors"
        echo "clamav_scan_exit_code $rc"
        echo "clamav_scan_full $full"
        echo "clamav_scan_changed_files $files"
        echo "clamav_scan_duration_seconds $(( $(date +%s) - start ))"
        echo "clamav_scan_timestamp_seconds $(date +%s)"
        head -n 100 "$open" \
          | jq -r '"clamav_infected_file{path=\(.path | tojson),signature=\(.signature | tojson)} 1"'
      } > ${textfileDir}/clamav.prom.tmp
      mv ${textfileDir}/clamav.prom.tmp ${textfileDir}/clamav.prom

      # The stamps move once clamdscan finished (it printed its summary), also with unreadable files:
      # those are counted in clamav_scan_errors, and keeping the old stamp would rescan a growing set
      # of files every night (or repeat the full scan). Only a scan that did not run keeps them.
      if (( ! full && files == 0 )) || grep -q '^Scanned files:' "$out"; then
        if (( full )); then
          cp -p "${stamp}.new" ${fullStamp}
        fi
        mv "${stamp}.new" ${stamp}
      fi
      exit "$rc"
    '';
  };

  homeManagerUser = config.home-manager.users.${userName} or null;
  downloadDir =
    if homeManagerUser != null && homeManagerUser.xdg.userDirs.enable then
      homeManagerUser.xdg.userDirs.download
    else
      "/home/${userName}/Downloads";
in

{
  options.nixos = {
    system.clamav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ClamAV virus scanner.";
      };

      extraScanDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "/mount/Data" ];
        description = "Additional directories of the nightly scan (user data, shares, uploads).";
      };

      excludePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "^/pool01/shares/video" ];
        description = "Regular expressions of paths that are not scanned (ExcludePath).";
      };

      acknowledged = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              path = lib.mkOption {
                type = lib.types.str;
                description = "Shell glob of the file path (`*` also matches `/`).";
              };
              signature = lib.mkOption {
                type = lib.types.str;
                description = "Shell glob of the ClamAV signature.";
              };
            };
          }
        );
        default = [ ];
        example = [
          {
            path = "/srv/old-mails/*";
            signature = "Email.Phishing.*";
          }
        ];
        description = "Findings checked by hand (path and signature). They stay in the findings list but leave the metrics, the dashboard and the alert MalwareFound; new findings in the same files still show up.";
      };

      fullScanDay = lib.mkOption {
        type = lib.types.ints.between 1 28;
        default = 1;
        description = "Day of the month with a full scan, the other nights only scan new and changed files. A host that was off that night catches up once the last full scan is older than 31 days.";
      };

      maxThreads = lib.mkOption {
        type = lib.types.ints.positive;
        default = 2;
        description = "Scan threads of clamd (cores used), clamd also runs with the lowest CPU and IO priority.";
      };

      onAccess = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.nixos.desktop.enable;
          defaultText = lib.literalExpression "config.nixos.desktop.enable";
          description = "Scan files in the listed directories when they are opened and block infected ones. clamd then runs permanently, otherwise only for the nightly scan.";
        };

        paths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            downloadDir
            "/tmp/mozilla_${userName}0"
          ];
          defaultText = lib.literalExpression ''[ <download directory of the user> "/tmp/mozilla_<user>0" ]'';
          description = "Directories checked on access: downloads and the directory Thunderbird opens attachments from.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.clamav = {
      daemon = {
        enable = true;
        settings = {
          ExcludePath = [
            "^/proc/"
            "^/sys/"
            # Own signatures (updated hourly) and the metrics written by the scan.
            "^/var/lib/clamav/"
            "^/var/lib/prometheus-node-exporter/"
            "/\\.zfs/"
            "/\\.snapshots/"
          ]
          ++ cfg.excludePaths;
          MaxThreads = cfg.maxThreads;
          # clamdscan --infected hides per-file errors, clamd logs them (and findings, not clean files)
          # to the journal: journalctl -u clamav-daemon | grep ERROR
          LogSyslog = true;
        }
        // lib.optionalAttrs cfg.onAccess.enable {
          OnAccessIncludePath = cfg.onAccess.paths;
          OnAccessPrevention = true;
          OnAccessMaxFileSize = "200M";
        };
      };

      clamonacc.enable = cfg.onAccess.enable;

      updater = {
        enable = true;
        interval = "hourly";
        frequency = 12;
      };

      scanner = {
        enable = true;
        interval = "*-*-* 04:00:00";
        scanDirectories = [
          "/home"
          "/var/lib"
          "/tmp"
          "/etc"
          "/var/tmp"
        ]
        ++ cfg.extraScanDirectories;
      };
    };

    systemd.services.clamav-daemon = {
      # Without on-access scanning the nightly scan starts and stops it.
      wantedBy = lib.mkIf (!cfg.onAccess.enable) (lib.mkForce [ ]);
      serviceConfig = {
        Nice = 19;
        IOSchedulingClass = "idle";
        # Stopping clamd would remove /run/clamav and with it the socket file of clamav-daemon.socket,
        # the next scan then fails with "Could not connect to clamd" although clamd runs.
        RuntimeDirectoryPreserve = true;
      };
    };

    # The include paths have to exist and be mounted before clamonacc marks them.
    systemd.services.clamav-clamonacc.unitConfig.RequiresMountsFor =
      lib.mkIf cfg.onAccess.enable cfg.onAccess.paths;
    systemd.tmpfiles.rules = lib.mkIf cfg.onAccess.enable [
      "d /tmp/mozilla_${userName}0 0700 ${userName} ${config.users.users.${userName}.group} -"
    ];

    # sudo clamdscan-metrics full: full scan by hand.
    environment.systemPackages = [ scan ];

    # A deploy must not restart a running scan: switch-to-configuration would wait for the oneshot to
    # finish (hours on NixOS-Server1), and the next deploy fails with "already loaded".
    systemd.services.clamdscan.restartIfChanged = false;
    systemd.services.clamdscan.serviceConfig = {
      ExecStart = lib.mkForce (lib.getExe scan);
      SuccessExitStatus = 1;
      Nice = 19;
      IOSchedulingClass = "idle";
    };

    # Clients are often off at 04:00, the missed scan runs after the next boot.
    systemd.timers.clamdscan.timerConfig.Persistent = true;

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/clamav"
      ];
    };
  };
}

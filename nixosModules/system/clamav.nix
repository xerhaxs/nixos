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

  excludes = pkgs.writeText "clamav-excludes" (
    lib.concatStringsSep "\n" clamav.daemon.settings.ExcludePath + "\n"
  );

  # Daily only new and changed files (ctime, so copies with an old mtime count as well), a full scan
  # on cfg.fullScanDay or without a stamp. Summary and findings go to the node exporter.
  scan = pkgs.writeShellApplication {
    name = "clamdscan-metrics";
    runtimeInputs = [
      clamav.package
      config.systemd.package
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.jq
    ];
    text = ''
      out="$(mktemp)"
      list="$(mktemp)"
      trap 'rm -f "$out" "$list"' EXIT
      start=$(date +%s)
      touch "${stamp}.new"

      full=0
      if [[ ''${1:-} == full || ! -e ${stamp} || $(date +%-d) == ${toString cfg.fullScanDay} ]]; then
        full=1
      fi

      ${lib.optionalString (!cfg.onAccess.enable) ''
        # clamd only runs for the scan, it holds the signatures in RAM (up to 3 GB).
        systemctl start clamav-daemon.service
        trap 'rm -f "$out" "$list"; systemctl stop clamav-daemon.service' EXIT
      ''}
      clamdscan --ping 60:5 > /dev/null

      set +e
      if (( full )); then
        clamdscan --multiscan --fdpass --infected --allmatch ${lib.escapeShellArgs clamav.scanner.scanDirectories} | tee "$out"
        rc=''${PIPESTATUS[0]}
        files=0
      else
        find ${lib.escapeShellArgs clamav.scanner.scanDirectories} -type f -cnewer ${stamp} 2> /dev/null \
          | grep -E -v -f ${excludes} > "$list"
        files=$(wc -l < "$list")
        rc=0
        if (( files > 0 )); then
          clamdscan --multiscan --fdpass --infected --allmatch --file-list="$list" | tee "$out"
          rc=''${PIPESTATUS[0]}
        fi
      fi
      set -e

      infected=$(sed -n 's/^Infected files: //p' "$out" | tail -n 1)
      errors=$(sed -n 's/^Total errors: //p' "$out" | tail -n 1)
      {
        echo "clamav_scan_infected_files ''${infected:-0}"
        echo "clamav_scan_errors ''${errors:-0}"
        echo "clamav_scan_exit_code $rc"
        echo "clamav_scan_full $full"
        echo "clamav_scan_changed_files $files"
        echo "clamav_scan_duration_seconds $(( $(date +%s) - start ))"
        echo "clamav_scan_timestamp_seconds $(date +%s)"
        { grep -m 100 ' FOUND$' "$out" || true; } \
          | jq -R -r 'capture("^(?<path>.*): (?<signature>[^ ]+) FOUND$")
              | "clamav_infected_file{path=\(.path | tojson),signature=\(.signature | tojson)} 1"'
      } > ${textfileDir}/clamav.prom.tmp
      mv ${textfileDir}/clamav.prom.tmp ${textfileDir}/clamav.prom

      # 0 clean, 1 found something (reported through the metrics), 2 error: keep the old stamp.
      if (( rc < 2 )); then
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

      fullScanDay = lib.mkOption {
        type = lib.types.ints.between 1 28;
        default = 1;
        description = "Day of the month with a full scan, the other nights only scan new and changed files.";
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

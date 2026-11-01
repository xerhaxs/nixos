let
  datasource = {
    type = "prometheus";
    uid = "prometheus";
  };

  target = expr: {
    inherit datasource expr;
    refId = "A";
    instant = true;
    format = "table";
  };

  panel =
    type: title: gridPos: expr: extra:
    {
      inherit
        type
        title
        gridPos
        datasource
        ;
      targets = [ (target expr) ];
    }
    // extra;

  stat =
    title: x: y: expr: steps:
    panel "stat" title
      {
        inherit x y;
        w = 6;
        h = 4;
      }
      expr
      {
        options = {
          colorMode = "background";
          graphMode = "none";
          reduceOptions.calcs = [ "lastNotNull" ];
        };
        fieldConfig.defaults.thresholds = {
          mode = "absolute";
          inherit steps;
        };
      };

  # Instant table, only the listed labels (and optionally the value) in this order.
  table =
    title: y: h: expr: columns:
    panel "table" title
      {
        x = 0;
        inherit y h;
        w = 24;
      }
      expr
      {
        options.sortBy = [ ];
        transformations = [
          {
            id = "organize";
            options = {
              excludeByName = {
                Time = true;
                __name__ = true;
                job = true;
              };
              renameByName = columns;
            };
          }
          {
            id = "filterFieldsByName";
            options.include.names = builtins.attrValues columns;
          }
        ];
      };

  greenAbove = limit: color: [
    {
      color = "green";
      value = null;
    }
    {
      inherit color;
      value = limit;
    }
  ];
in

{
  uid = "security-updates";
  title = "Security und Updates";
  tags = [ "nixos" ];
  timezone = "browser";
  refresh = "5m";
  schemaVersion = 39;
  time = {
    from = "now-30d";
    to = "now";
  };

  panels = [
    (stat "Kritische CVEs (Kandidaten)" 0 0 ''sum(nixos_cve_open{severity="Critical"})'' (
      greenAbove 1 "red"
    ))
    (stat "Hohe CVEs (Kandidaten)" 6 0 ''sum(nixos_cve_open{severity="High"})'' (greenAbove 1 "orange"))
    (stat "Hosts mit Neustart-Bedarf" 12 0 "sum(nixos_reboot_required)" (greenAbove 1 "orange"))
    (stat "Verfügbare Updates" 18 0 "sum(nixos_update_available)" (greenAbove 1 "blue"))

    (table "Notwendige Aktualisierungen: Pins und Container-Images" 4 9 "nixos_update_available == 1" {
      kind = "Art";
      name = "Name";
      current = "Aktuell";
      latest = "Neu";
    })

    (table "Alter der Flake-Inputs (Tage)" 13 9
      "(time() - nixos_flake_input_last_modified_seconds{instance=\"NixOS-Server1\"}) / 86400"
      {
        input = "Input";
        rev = "Revision";
        Value = "Tage";
      }
    )

    (table "Stand der Hosts" 22 7 "nixos_system_info" {
      instance = "Host";
      revision = "Commit";
      kernel = "Kernel";
    })

    (table "Offene CVEs je Host" 29 7 "nixos_cve_open" {
      instance = "Host";
      severity = "Schweregrad";
      Value = "Anzahl";
    })

    (table "Kritische und hohe CVEs (Kandidaten, Abgleich nach Name und Version)" 36 14
      "nixos_cve_package"
      {
        instance = "Host";
        severity = "Schweregrad";
        cve = "CVE";
        package = "Paket";
        version = "Version";
        fixed_in = "Behoben in";
      }
    )

    (table "Letzter Scan (Tage her)" 50 7 "(time() - nixos_cve_scan_timestamp_seconds) / 86400" {
      instance = "Host";
      Value = "Tage";
    })
  ];
}

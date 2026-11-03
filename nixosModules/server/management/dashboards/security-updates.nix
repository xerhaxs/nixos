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
  title = "Security and Updates";
  tags = [ "nixos" ];
  timezone = "browser";
  refresh = "5m";
  schemaVersion = 39;
  time = {
    from = "now-30d";
    to = "now";
  };

  panels = [
    (stat "Critical CVEs (candidates)" 0 0 ''sum(nixos_cve_open{severity="Critical"})'' (
      greenAbove 1 "red"
    ))
    (stat "High CVEs (candidates)" 6 0 ''sum(nixos_cve_open{severity="High"})'' (greenAbove 1 "orange"))
    (stat "Hosts needing a reboot" 12 0 "sum(nixos_reboot_required)" (greenAbove 1 "orange"))
    (stat "Available updates" 18 0 "sum(nixos_update_available)" (greenAbove 1 "blue"))

    (table "Pending updates: pins and container images" 4 9 "nixos_update_available == 1" {
      kind = "Kind";
      name = "Name";
      current = "Current";
      latest = "Latest";
    })

    (table "Age of the flake inputs (days)" 13 9
      "(time() - nixos_flake_input_last_modified_seconds{instance=\"NixOS-Server1\"}) / 86400"
      {
        input = "Input";
        rev = "Revision";
        Value = "Days";
      }
    )

    (table "Host versions" 22 7 "nixos_system_info" {
      instance = "Host";
      revision = "Commit";
      kernel = "Kernel";
    })

    (table "Open CVEs per host" 29 7 "nixos_cve_open" {
      instance = "Host";
      severity = "Severity";
      Value = "Count";
    })

    (table "Critical and high CVEs (candidates, matched by name and version)" 36 14
      "nixos_cve_package"
      {
        instance = "Host";
        severity = "Severity";
        cve = "CVE";
        package = "Package";
        version = "Version";
        fixed_in = "Fixed in";
      }
    )

    (table "Last scan (days ago)" 50 7 "(time() - nixos_cve_scan_timestamp_seconds) / 86400" {
      instance = "Host";
      Value = "Days";
    })
  ];
}

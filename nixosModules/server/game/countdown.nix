{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.game.countdown;
  nginxCfg = config.nixos.server.network.nginx;

  page = pkgs.writeTextDir "index.html" (
    builtins.replaceStrings
      [
        "@title@"
        "@subtitle@"
        "@target@"
        "@doneText@"
      ]
      [
        (lib.escapeXML cfg.title)
        (lib.escapeXML cfg.subtitle)
        cfg.target
        (lib.escape [ ''"'' "\\" ] cfg.doneText)
      ]
      (builtins.readFile ./countdown.html)
  );
in

{
  options.nixos = {
    server.game.countdown = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the countdown website on countdown.<domain>.";
      };

      target = lib.mkOption {
        type = lib.types.strMatching "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(Z|[+-][0-9]{2}:[0-9]{2})";
        example = "2027-01-01T18:00:00+01:00";
        description = "End of the countdown (ISO 8601 with time zone).";
      };

      title = lib.mkOption {
        type = lib.types.str;
        description = "Headline of the page.";
      };

      subtitle = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Line below the headline.";
      };

      doneText = lib.mkOption {
        type = lib.types.str;
        description = "Headline shown when the countdown has ended.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."countdown.${nginxCfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;
      kTLS = true;
      http2 = true;
      root = page;
      extraConfig = ''
        ${nginxCfg.securityHeaders}
        add_header Content-Security-Policy "default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'" always;
        add_header X-Robots-Tag "noindex" always;
      '';
    };
  };
}

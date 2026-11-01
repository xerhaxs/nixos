{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.tools.codeserver;
  hostname = "code.${config.nixos.server.network.nginx.domain}";
  home = "/home/${cfg.user}";
in

{
  options.nixos = {
    server.tools.codeserver = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable code-server (VS Code in the browser) with LaTeX.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "jf";
        description = "Unprivileged user code-server runs as (no wheel).";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "10.100.0.1";
        description = "Address nginx serves code-server on (WireGuard IP of the host).";
      };

      texlive = lib.mkOption {
        type = lib.types.package;
        default = pkgs.texliveFull;
        defaultText = lib.literalExpression "pkgs.texliveFull";
        example = lib.literalExpression "pkgs.texlive.combined.scheme-medium";
        description = "TeX Live distribution available in code-server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."codeserver/env" = { };

    users.users.${cfg.user} = {
      isNormalUser = true;
      group = "users";
      createHome = true;
      inherit home;
      description = "code-server";
    };

    services.code-server = {
      enable = true;
      user = cfg.user;
      group = "users";
      host = "127.0.0.1";
      port = 4444;
      auth = "password";
      disableTelemetry = true;
      disableUpdateCheck = true;
      disableGettingStartedOverride = true;
      userDataDir = "${home}/.local/share/code-server";
      extensionsDir = "${home}/.local/share/code-server/extensions";
      extraPackages = with pkgs; [
        cfg.texlive
        texlab
        ghostscript
        biber
        git
        nixd
        nixfmt
        gnumake
      ];
    };

    systemd.services.code-server = {
      serviceConfig.EnvironmentFile = config.sops.secrets."codeserver/env".path;

      preStart = ''
        ${lib.getExe config.services.code-server.package} \
          --extensions-dir=${config.services.code-server.extensionsDir} \
          --install-extension james-yu.latex-workshop || true
      '';
    };

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          listenAddresses = [ cfg.listenAddress ];
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.code-server.port}";
            proxyWebsockets = true;
          };
        };
      };
    };

    systemd.services.nginx = lib.mkIf config.nixos.system.wireguard.enable {
      wants = [ "wireguard-${config.nixos.system.wireguard.interface}.service" ];
      after = [ "wireguard-${config.nixos.system.wireguard.interface}.service" ];
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        {
          directory = home;
          user = cfg.user;
          group = "users";
          mode = "0700";
        }
      ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Secrets of the server services, read from server/<name> in nixos-portable.yaml, so the portable
  # host never shares a value with NixOS-Server1. Add every secret of a newly enabled service here.
  serverSecrets = [
    "codeserver/env"
    "forgejo/secret"
    "forgejo/token"
    "glance"
    "linkwarden/postgres"
    "linkwarden/secret"
    "radicale/htpasswd"
    "searxng/secret"
    "smb-share/user-jf"
    "smb-share/user-meli"
    "webdav-share/user-jf"
  ];
in
{
  # Second boot entry "server": the offline capable services of NixOS-Server1 and NixOS-ServerPublic on
  # this machine, reachable as https://<service>.portable.internal (self-signed certificate, /etc/hosts).
  specialisation.server.configuration =
    { config, ... }:
    {
      system.nixos.tags = [ "server" ];

      nixos.server.dataDir = "/persistent/server";

      nixos.server = {
        entertainment.jellyfin.enable = true;
        fileshare = {
          samba.enable = true;
          share.enable = true;
          webdav.enable = true;
        };
        management = {
          glance.enable = true;
          homeassistant.enable = true;
          homebox.enable = true;
          monitoring = {
            enable = true;
            nodes = {
              NixOS-Portable = "127.0.0.1";
            };
            probes = map (name: "https://${name}") (
              lib.filter (name: lib.hasSuffix ".${config.nixos.server.network.nginx.domain}" name) (
                lib.attrNames config.services.nginx.virtualHosts
              )
            );
          };
        };
        network.nginx = {
          enable = true;
          challenge = "selfsigned";
          domain = "portable.internal";
        };
        public = {
          cryptpad.enable = true;
          miniflux.enable = true;
        };
        sync = {
          forgejo.enable = true;
          linkwarden.enable = true;
          radicale.enable = true;
        };
        tools = {
          codeserver = {
            enable = true;
            listenAddress = "127.0.0.1";
            user = "code";
          };
          comfyui.enable = true;
          kiwix.enable = true;
          languagetool.enable = true;
          libretranslate.enable = true;
          ollama = {
            enable = true;
            models = [ "qwen3.5:4b" ];
          };
          searxng.enable = true;
        };
      };

      sops.secrets = lib.genAttrs serverSecrets (name: {
        key = "server/${name}";
      });

      networking.hosts."127.0.0.1" = lib.filter (name: name != "_") (
        lib.attrNames config.services.nginx.virtualHosts
      );
    };
}

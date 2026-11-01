{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Second boot entry "server": the offline capable services of NixOS-Server1 and NixOS-ServerPublic on
  # this machine, reachable as https://<service>.portable.internal (self-signed certificate, /etc/hosts).
  specialisation.server.configuration =
    { config, ... }:
    {
      imports = [
        ../NixOS-ServerPublic/minecraft.nix
      ];

      system.nixos.tags = [ "server" ];

      nixos.server.dataDir = "/persistent/server";

      nixos.server = {
        entertainment.jellyfin.enable = true;
        fileshare = {
          samba.enable = true;
          share.enable = true;
          webdav.enable = true;
        };
        game.minecraft.enable = true;
        management = {
          glance.enable = true;
          homeassistant.enable = true;
          homebox.enable = true;
          monitoring.enable = true;
        };
        network.nginx = {
          enable = true;
          challenge = "selfsigned";
          domain = "portable.internal";
        };
        public = {
          collabora.enable = true;
          cryptpad.enable = true;
          miniflux.enable = true;
          nextcloud.enable = true;
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

      services.minecraft-servers.servers.flolserver.jvmOpts =
        lib.mkForce "-Xmx4096M -Dlog4j2.formatMsgNoLookups=true";

      networking.hosts."127.0.0.1" = lib.filter (name: name != "_") (
        lib.attrNames config.services.nginx.virtualHosts
      );
    };
}

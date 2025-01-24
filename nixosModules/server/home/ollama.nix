{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.ollama = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Ollama.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.ollama.enable {
    services.ollama = {
      enable = true;
      host = "127.0.0.1";
      port = 11434;
      openFirewall = false;
      models = "\${config.services.ollama.home}/models";
    };

    services.nextjs-ollama-llm-ui = {
      enable = true;
      hostname = "127.0.0.1";
      port = 11440;
    };
    
    services.nginx = {
      virtualHosts = {
        "ollama.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:11440";
          };
        };
      };
    };

    services.ddclient.domains = [
      "ollama.${config.nixos.server.network.nginx.domain}"
    ];
  };
}

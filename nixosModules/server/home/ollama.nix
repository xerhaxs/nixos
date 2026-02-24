{
  config,
  lib,
  pkgs,
  ...
}:

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
      user = "ollama";
      group = "ollama";
      host = "127.0.0.1";
      port = 11434;
      openFirewall = false;
      syncModels = true;
      environmentVariables = {
        OLLAMA_VULKAN = 1;
      };
      models = "/pool01/applications/ollama/models";
      #models = "/var/lib/ollama/models";
      loadModels = [
        "deepseek-r1:1.5b"
        "deepseek-r1:7b"
        "deepseek-r1:8b"
        "deepseek-r1:14b"
        "deepseek-r1:32b"
        #deepseek-v3:671b
        "gemma3:270m"
        "gemma3:1b"
        "gemma3:4b"
        "gemma3:12b"
        "gemma3:27b"
        "gpt-oss:20b"
        #gpt-oss:120b
        "llama3.1:8b"
        #llama3.1:70b
        #llama3.1:405b
        "llama3.2:3b"
        "nemotron-3-nano:30b"
      ];
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
  };
}

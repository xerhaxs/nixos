{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.tools.ollama = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Ollama.";
      };

      gpu = lib.mkOption {
        type = lib.types.enum [
          "any"
          "amd"
          "intel"
        ];
        default = "any";
        example = "intel";
        description = "Restrict the Vulkan backend to the GPUs of one vendor (selects the Vulkan driver file).";
      };

      models = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "deepseek-r1:1.5b"
          "deepseek-r1:7b"
          "deepseek-r1:8b"
          "deepseek-r1:14b"
          "deepseek-r1:32b"
          "gemma3:270m"
          "gemma3:1b"
          "gemma3:4b"
          "gemma3:12b"
          "gemma3:27b"
          "gpt-oss:20b"
          "llama3.1:8b"
          "llama3.2:3b"
          "nemotron-3-nano:30b"
          "qwen3.5:9b"
          "qwen3.5:27b"
          "qwen3.5:35b"
        ];
        description = "Models pulled at startup.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.tools.ollama.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      user = "ollama";
      group = "ollama";
      host = "127.0.0.1";
      port = 11434;
      openFirewall = false;
      syncModels = true;
      environmentVariables = {
        OLLAMA_VULKAN = "1";
      }
      // lib.optionalAttrs (config.nixos.server.tools.ollama.gpu != "any") {
        VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/${
          {
            amd = "radeon";
            intel = "intel";
          }
          .${config.nixos.server.tools.ollama.gpu}
        }_icd.x86_64.json";
      };
      modelsDir = "${config.nixos.server.dataDir}/ollama/models";
      #models = "/var/lib/ollama/models";
      loadModels = config.nixos.server.tools.ollama.models;
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
          http2 = true;
          locations."/" = {
            proxyPass = "http://localhost:11440";
          };
        };
      };
    };
  };
}

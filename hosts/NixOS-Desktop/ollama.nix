{ config, lib, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    openFirewall = false;
    models = "\${config.services.ollama.home}/models";
    loadModels = [
      deepseek-r1:1.5b
      deepseek-r1:7b
      deepseek-r1:8b
      deepseek-r1:14b
      deepseek-r1:32b
    ];
  };

  services.nextjs-ollama-llm-ui = {
    enable = true;
    hostname = "127.0.0.1";
    port = 11440;
  };
}

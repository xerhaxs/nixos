{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.ollama = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Ollama.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.ollama.enable {
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
  };
}

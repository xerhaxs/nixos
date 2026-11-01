{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.server.tools.comfyui;
  dataDir = "${config.nixos.server.dataDir}/comfyui";
in

{
  options.nixos = {
    server.tools.comfyui = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ComfyUI (Stable Diffusion) in a podman container with Intel GPU (XPU) acceleration.";
      };

      image = lib.mkOption {
        type = lib.types.str;
        default = (lib.importJSON ../../../pkgs/images.json).comfyui;
        defaultText = lib.literalExpression "comfyui in pkgs/images.json";
        description = "Container image, pinned to a digest. Variants: xpu (Intel), rocm (AMD), cpu.";
      };

      extraArgs = lib.mkOption {
        type = lib.types.str;
        default = "--enable-manager";
        example = "--lowvram --enable-manager";
        description = "Additional ComfyUI command line arguments (CLI_ARGS).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.comfyui = {
      image = cfg.image;

      ports = [
        "127.0.0.1:8188:8188"
      ];

      environment = {
        CLI_ARGS = cfg.extraArgs;
      };

      volumes = [
        "${dataDir}/storage:/root"
        "${dataDir}/models:/root/ComfyUI/models"
        "${dataDir}/hf-hub:/root/.cache/huggingface/hub"
        "${dataDir}/torch-hub:/root/.cache/torch/hub"
        "${dataDir}/input:/root/ComfyUI/input"
        "${dataDir}/output:/root/ComfyUI/output"
        "${dataDir}/user:/root/ComfyUI/user"
      ];

      extraOptions = [
        "--device=/dev/dri"
        "--ipc=host"
      ];
    };

    systemd.tmpfiles.rules = map (dir: "d ${dataDir}/${dir} 0750 root root -") [
      "storage"
      "models"
      "hf-hub"
      "torch-hub"
      "input"
      "output"
      "user"
    ];

    services.nginx = {
      virtualHosts = {
        "comfyui.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8188";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 100M;
            '';
          };
        };
      };
    };
  };
}

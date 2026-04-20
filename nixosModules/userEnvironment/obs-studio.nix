{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.obs-studio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable obs-studio virtual camera module.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.obs-studio.enable {
    #boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    #boot.extraModprobeConfig = ''
    #  options devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1 4l2loopback
    #'';

    programs.obs-studio.enableVirtualCamera = true;
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    hardware.nvidiagpu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable nvidiagpu support.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.nvidiagpu.enable {
    boot.initrd.kernelModules = [ "nvidia" ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };

    hardware.nvidia = {
      modesetting.enable = true;

      open = true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement.enable = true;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";

      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}

{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    hardware.nvidiagpu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable nvidiagpu support.";
      };
    };
  };

  config = mkIf config.nixos.hardware.nvidiagpu.enable {
    boot.initrd.kernelModules = [ "nvidia" ];

    # Make sure opengl is enabled
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Tell Xorg to use the nvidia driver
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };

    hardware.nvidia = {

      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;

      # Use the open source version of the kernel module
      # Only available on driver 515.43.04+
      open = true;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.sessionVariables = {
      # If the cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";

      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };
  };
}

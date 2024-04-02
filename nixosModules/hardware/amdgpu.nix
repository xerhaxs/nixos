{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    hardwrae.amdgpu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable amdgpu support.";
      };
    };
  };

  config = mkIf config.nixos.hardware.amdgpu.enable {
    # Enable OpenCL & Vulkan
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.opengl = {
    enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        driversi686Linux.amdvlk
      ];
    };

    # Tell Xorg to use the amd driver
    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

    # Workaround for HIP GPU acceleration on AMD APUs
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    #environment.variables.AMD_VULKAN_ICD = "RADV";

    #environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };
}

{ config, lib, pkgs, ... }:

{
  options.nixos = {
    hardware.amdgpu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable amdgpu support.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.amdgpu.enable {
    # Enable OpenCL & Vulkan
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        driversi686Linux.amdvlk
      ];
    };

    hardware.amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
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

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
    ];
  };
}

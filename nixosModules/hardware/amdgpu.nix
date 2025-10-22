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
    };

    hardware.amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };

    # Tell Xorg to use the amd driver
    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

    # Workaround for HIP GPU acceleration on AMD APUs
    systemd.tmpfiles.rules = 
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
      vulkan-tools
    ];
  };
}

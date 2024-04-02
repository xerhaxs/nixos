{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    hardware.intelgpu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable intelgpu support.";
      };
    };
  };

  config = mkIf config.nixos.hardware.intelgpu.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
    };
  };
}
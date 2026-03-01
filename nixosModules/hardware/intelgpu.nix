{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    hardware.intelgpu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable intelgpu support.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.intelgpu.enable {
    hardware.intel-gpu-tools.enable = true;

    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        vpl-gpu-rt
        libvdpau-va-gl
        intel-compute-runtime
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.intel
    ];
  };
}

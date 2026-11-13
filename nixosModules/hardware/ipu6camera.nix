{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    hardware.ipu6camera = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Cameras on the Intel IPU6 through libcamera (mainline driver, software ISP) and PipeWire. The sensors also need kernel support for the board, see docs/workarounds.md.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.ipu6camera.enable {
    hardware.enableRedistributableFirmware = lib.mkDefault true;

    # cam -l lists the cameras, qcam shows the picture, libcamerify runs V4L2-only programs.
    environment.systemPackages = with pkgs; [
      libcamera
      libcamera-qcam
    ];

    # The IPU6 creates a raw capture node per CSI port. libcamera uses them directly, through
    # V4L2 they only deliver raw Bayer data and would show up as a dozen black cameras.
    services.pipewire.wireplumber.extraConfig."50-ipu6-camera" = {
      "monitor.v4l2.rules" = [
        {
          matches = [ { "api.v4l2.cap.driver" = "isys"; } ];
          actions.update-props."device.disabled" = true;
        }
      ];
    };

    users.users.${userName}.extraGroups = [ "video" ];
  };
}

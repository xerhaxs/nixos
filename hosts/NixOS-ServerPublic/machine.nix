{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "26.05";

  nixos.system.initrdssh = {
    enable = true;
    port = 2222;
    kernelModules = [ "virtio_net" ];
  };

  services.qemuGuest.enable = true;
}

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
    ip =
      let
        net = config.nixos.site.serverPublic;
        netmask =
          {
            "24" = "255.255.255.0";
            "25" = "255.255.255.128";
            "26" = "255.255.255.192";
            "27" = "255.255.255.224";
            "28" = "255.255.255.240";
            "29" = "255.255.255.248";
            "32" = "255.255.255.255";
          }
          .${toString net.ipv4PrefixLength};
      in
      "${net.ipv4}::${net.ipv4Gateway}:${netmask}::${net.interface}:none";
  };

  services.qemuGuest.enable = true;
}

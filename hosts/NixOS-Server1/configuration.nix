{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
    intelgpu.enable = true;
  };

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 22;
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyndaaCmTLHdA5+sLBbxgSZNC6KXKtZkKiMK6AAY8Rt jf@NixOS-Desktop" ];
      hostKeys = [ "/etc/ssh/initrd_host_key" ]; # generate keys with "ssh-keygen -t ed25519 -N "" -f /etc/ssh/initrd_host_key"
    };
  };

  boot.initrd.secrets = {
    "/etc/ssh/initrd_host_key" = "/etc/ssh/initrd_host_key";
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$MXbWf.peSOtvQQtYvZvuZ.$7XUvmCniT4h4o.SFaGqD29F13RWyGW7bNpBcMpHKHH3";
    #passfile = config.sops.secrets."user/nixos-server1/admin".path;
  };

  services.qemuGuest.enable = true;
}

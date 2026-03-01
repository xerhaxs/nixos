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
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyndaaCmTLHdA5+sLBbxgSZNC6KXKtZkKiMK6AAY8Rt jf@NixOS-Desktop"
      ];
      hostKeys = [ "/etc/ssh/initrd_host_key" ];
      # generate keys with "ssh-keygen -t ed25519 -N "" -f /etc/ssh/initrd_host_key"
      # ssh root@10.75.0.21
      # enter disk password "systemd-tty-ask-password-agent --query"
    };
  };

  boot.initrd.availableKernelModules = [
    "r8169"
  ];

  #boot.kernelParams = [ "ip=10.75.0.21::10.75.0.1:255.255.255.0::eno1:none" ];

  boot.initrd.secrets = {
    "/etc/ssh/initrd_host_key" = "/etc/ssh/initrd_host_key";
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$MXbWf.peSOtvQQtYvZvuZ.$7XUvmCniT4h4o.SFaGqD29F13RWyGW7bNpBcMpHKHH3";
    #passfile = config.sops.secrets."user/nixos-server1/admin".path;
  };

  nixos.system.secureboot.enable = true;
}

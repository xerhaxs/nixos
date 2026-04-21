{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  _module.args.userName = "admin";

  users.users.${userName} = {
    initialHashedPassword = "$y$j9T$ZEmmQ3X2ZJ2SjdORzgtXH1$n7.HG3CbcKpKv1gZjrAhbFJzqsjNNUsh7mCxxzoEPbB";
    #hashedPasswordFile = config.sops.secrets."user/nixos-vmserver/admin".path;
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  services.getty.autologinUser = null;

  services.qemuGuest.enable = true;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}

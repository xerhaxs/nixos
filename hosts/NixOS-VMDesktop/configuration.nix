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
    initialHashedPassword = "$y$j9T$1/B9SU/ligzAtWZfeWUkN0$HpnDuMQ26LrBrhTxQrapc2Fx/q3MfL.kX27D4jL87o/";
    #hashedPasswordFile = config.sops.secrets."user/nixos-vmdesktop/admin".path;
  };

  nixos.desktop = {
    enable = true;
    desktopEnvironment = {
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "plasma";
      sddm.enable = true;
    };
    windowManager = {
      hyprland.enable = false;
    };
  };

  nixos.theme.catppuccin = {
    accent = "Mauve";
    flavor = "Mocha";
  };

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.userEnvironment.enable = true;

  services.qemuGuest.enable = true;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}

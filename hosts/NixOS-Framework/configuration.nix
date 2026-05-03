{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  _module.args.userName = "jf";

  users.users.${userName} = {
    initialHashedPassword = "$y$j9T$VLRm4nCKGD/ww64EwANZr0$Jrfk/VugVr/U7LP82BGFD.wlKOqwDAatzcZCAOOSRs2";
    #hashedPasswordFile = config.sops.secrets."user/nixos-framework/jf".path;
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

  nixos.system.secureboot.enable = true; # NEED TO BE CHANGED!!

  nixos.userEnvironment.enable = true;

  nixos.virtualisation.android.enable = true;
  nixos.virtualisation.kvm.enable = true;
}

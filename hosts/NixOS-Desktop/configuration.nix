{ config, lib, pkgs, ... }:

{
  nixos.desktop.enable = true;

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "jf";
    pass = "$y$j9T$NIfKOLrAK89gT5XGx20xK1$wrK821uQS6HRoh6FBlifDpJ2qakLfIWv8C8vyEwnpT/";
  };

  nixos.userEnvironment.enable = true;

  nixos.virtualisation.android.enable = true;
  nixos.virtualisation.kvm.enable = true;
}
{ config, lib, pkgs, ... }:

{
  nixos.hardware = {
  #  amdcpu.enable = true;
  #  amdgpu.enable = true;
    intelcpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$Uw0bBhVDwTfmALp.YDhjZ0$CtX1vofm.Wq2UUQ4JICMtVUXBYvWla7.cDoIhH9ZNl.";
  };

  #services.qemuGuest.enable = true;
}
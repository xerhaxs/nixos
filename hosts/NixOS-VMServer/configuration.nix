{ config, lib, pkgs, ... }:

{
  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$HDk4CbWnR9fWeTkI/byxp.$f2hONNjOT8hsi0gg74t8HafjzT/de33PWIRJEhfREB7"; # CHANGEME
  };

  services.qemuGuest.enable = true;
}
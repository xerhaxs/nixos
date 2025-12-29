{ config, lib, pkgs, ... }:

{
  nixos.system.user.defaultuser = {
    name = "admin";
    pass = "$y$j9T$GoLuMdK9I2QfEAZ3K80KA0$Fgay3PXjsB3UZgZ70nlFYk/3qhEYlx4jmYx4/CyWI6/"; # CHANGEME
  };
}
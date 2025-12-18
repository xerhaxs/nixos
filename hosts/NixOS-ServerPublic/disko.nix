{ config, disko, lib, pkgs, ... }: 

{
  imports = [
    disko.nixosModules.disko
  ];

  disko.devices = {
    disko.devices = {
      mdadm = {
        raid1 = {
          type = "mdadm";
          level = 1;
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  label = "boot";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  label = "root";
                  mountpoint = "/";
                };
              };
              home = {
                size = "50G"; # optional
                content = {
                  type = "filesystem";
                  format = "ext4";
                  label = "home";
                  mountpoint = "/home";
                };
              };
            };
          };
        };
      };

      disk = {
        disk1 = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              esp = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  label = "esp_sda";
                  mountpoint = "/boot/efi";
                };
              };
            };
          };
        };

        disk2 = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              esp = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  label = "esp_sdb";
                  mountpoint = "/boot/efi2";
                };
              };
            };
          };
        };
      };
    };
  };
}
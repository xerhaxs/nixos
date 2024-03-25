{ disks ? [ "/dev/vda" ], ... }:

{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        name = "SYSTEM";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              name = "BOOT";
              content = {
                type = "filesystem";
                extraArgs = "-L BOOT";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              extraArgs = "--label CRYPTDRIVE";
              content = {
                type = "luks";
                name = "LUKS";
                extraOpenArgs = [ "--label CRYPTDRIVE" "--cipher aes-xts-plain64" "--key-size 512" "--hash sha512" ];
                settings = {
                  keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                additionalKeyFiles = [ "/tmp/keyfile.key" ];
                content = {
                  type = "lvm_pv";
                  vg = "crypt";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      crypt = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "40%FREE";
            extraArgs = "-L root";
            content = {
              type = "filesystem";
              extraArgs = "-L root";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
          home = {
            size = "100%FREE";
            extraArgs = "-L home";
            content = {
              type = "filesystem";
              extraArgs = "-L home";
              format = "ext4";
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}
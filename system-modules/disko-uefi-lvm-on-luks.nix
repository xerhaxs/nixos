{ disks ? [ "/dev/vda" ], ... }:

{
  disko.devices = {
    disk = {
      vda = {
        name = "SYSTEM";
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "BOOT";
              type = "EF00";
              size = "500M";
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
              name = "CRYPT";
              size = "100%";
              content = {
                type = "luks";
                name = "TEST";
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
            name = "root";
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
            name = "home";
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
{ disks ? [ "/dev/vda" ], ... }:
  
{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        name = "SYSTEM";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "BOOT";
              start = "1M";
              end = "500M";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            }
            {
              name = "luks";
              start = "500M";
              end = "100%";
              content = {
                type = "luks";
                name = "LUKS";
                extraOpenArgs = [ "--cipher aes-xts-plain64" "--key-size 512" "--hash sha512" ];
                settings = {
                  # if you want to use the key for interactive login be sure there is no trailing newline
                  # for example use `echo -n "password" > /tmp/secret.key`
                  keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "lvm_pv";
                  vg = "crypt";
                };
              };
            }
          ];
        };
      };
    };
    lvm_vg = {
      crypt = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "40%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
          home = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}

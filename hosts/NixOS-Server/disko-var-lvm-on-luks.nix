{ disks ? [ "/dev/vda" ], ... }:

{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        name = "VAR";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "LUKS";
                extraOpenArgs = [ "--cipher aes-xts-plain64" "--key-size 512" "--hash sha512" ];
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
          var = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
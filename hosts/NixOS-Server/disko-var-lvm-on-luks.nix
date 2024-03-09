{ disks ? [ "/dev/vdb" ], ... }:

{
  disko.devices = {
    disk = {
      vdb = {
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
                name = "LUKS2";
                extraOpenArgs = [ "--cipher aes-xts-plain64" "--key-size 512" "--hash sha512" ];
                settings = {
                  keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                additionalKeyFiles = [ "/tmp/keyfile.key" ];
                content = {
                  type = "lvm_pv";
                  vg = "crypt2";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      crypt2 = {
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
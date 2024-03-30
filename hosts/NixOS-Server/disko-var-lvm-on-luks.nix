{ disks ? [ "/dev/vdb" ], ... }:

{
  disko.devices = {
    disk = {
      vdb = {
        name = "VAR";
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            luks = {
              name = "CRYPT2";
              size = "100%";
              content = {
                name = "LUKS2";
                type = "luks";
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
            name = "var";
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
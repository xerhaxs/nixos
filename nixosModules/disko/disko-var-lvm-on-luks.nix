{ config, disks ? [ "/dev/vdb" ], lib, pkgs, ... }:
  
{
  options.nixos = {
    disko.disko-var-lvm-on-luks = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-var-lvm-on-luks.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-var-lvm-on-luks.enable {
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
                name = "LUKS2";
                size = "100%";
                content = {
                  name = "system2";
                  type = "luks";
                  extraOpenArgs = [
                    "--timeout 10"
                  ];
                  settings = {
                    keyFile = "/tmp/secret.key";
                    allowDiscards = true;
                  };
                  initrdUnlock = true;
                  additionalKeyFiles = [ "/tmp/keyfile.key" ];
                  content = {
                    type = "lvm_pv";
                    vg = "crypt2";
                  };
                  extraFormatArgs = [
                    "--type luks2"
                    "--cipher aes-xts-plain64"
                    "--hash sha512"
                    "--iter-time 2000"
                    "--key-size 512"
                    "--pbkdf argon2id"
                    "--use-random"
                    "--label LUKS2"
                  ];
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
                extraArgs = [ "-L var" ];
              };
            };
          };
        };
      };
    };
  };
}
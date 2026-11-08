{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.initrdssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ssh in initrd to unlock encrypted disks remotely.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 22;
        description = "Port of the initrd ssh server.";
      };

      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = config.nixos.system.ssh.authorizedKeys;
        description = "Public keys allowed to unlock the disk.";
      };

      hostKey = lib.mkOption {
        type = lib.types.str;
        default =
          if config.nixos.disko.disko-luks-btrfs-tmpfs.enable then
            "/persistent/etc/ssh/initrd_host_key"
          else
            "/etc/ssh/initrd_host_key";
        defaultText = lib.literalExpression ''"/persistent/etc/ssh/initrd_host_key" with impermanence, else "/etc/ssh/initrd_host_key"'';
        description = "Path of the initrd ssh host key.";
      };

      kernelModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "r8169" ];
        description = "Network driver modules needed in initrd.";
      };

      ip = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "203.0.113.10::203.0.113.1:255.255.255.0::ens3:none";
        description = "Static network configuration for initrd as kernel parameter ip=. DHCP is used if null.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.initrdssh.enable {
    boot.initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = config.nixos.system.initrdssh.port;
        authorizedKeys = config.nixos.system.initrdssh.authorizedKeys;
        hostKeys = [ config.nixos.system.initrdssh.hostKey ];
      };
    };

    boot.initrd.availableKernelModules = config.nixos.system.initrdssh.kernelModules;

    boot.kernelParams = lib.mkIf (config.nixos.system.initrdssh.ip != null) [
      "ip=${config.nixos.system.initrdssh.ip}"
    ];

    boot.initrd.secrets = {
      "${config.nixos.system.initrdssh.hostKey}" = config.nixos.system.initrdssh.hostKey;
    };
  };
}

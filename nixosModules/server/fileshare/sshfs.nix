{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fileshare.sshfs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable sshfs file share.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fileshare.sshfs.enable {
    services.openssh.allowSFTP = true;

    users.users."${config.nixos.system.user.defaultuser.name}" = {
      extraGroups = [
        "share"
      ];
    };
  };
}
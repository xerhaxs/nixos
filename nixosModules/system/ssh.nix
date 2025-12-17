{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ssh with sshguard.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.ssh.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      openFirewall = true;
      #allowSFTP = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
      };
    };

    services.sshguard = {
      enable = true;
      services = [ "sshd" ];
      whitelist = [
        "10.75.0.40"
        "10.75.0.80"
      ];
      blocktime = 3600;
      detection_time = 30758400;
      blacklist_threshold = 60;
      attack_threshold = 10;
    };

    services.sshd.enable = true;
  };
}

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
      X11Forwarding = false;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
      };
    };

    services.sshd = {
      enable = true;
      services = [ "sshd" ];
      whitelist = [ 
        "10.75.0.40"
        "10.75.0.80"
      ];
      blocktime = 120;
    };
  };
}

{
  briar-mailbox,
  config,
  lib,
  pkgs,
  ...
}:

let
  src = briar-mailbox;
  version = briar-mailbox.shortRev;

  image = "localhost/briar-mailbox:${version}";
  podman = "${config.virtualisation.podman.package}/bin/podman";
in

{
  options.nixos = {
    server.public.briar-mailbox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Briar Mailbox.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.briar-mailbox.enable {
    nixos.virtualisation.podman.enable = true;

    systemd.services.briar-mailbox-image = {
      description = "Build the Briar Mailbox container image ${version}";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutStartSec = "1h";
      };
      script = ''
        if ! ${podman} image exists ${image}; then
          ${podman} build --pull=missing --tag ${image} ${src}
        fi
      '';
    };

    virtualisation.oci-containers.containers.briar-mailbox = {
      inherit image;
      pull = "never";
      autoStart = true;
      volumes = [ "/var/lib/briar-mailbox:/root" ];
      extraOptions = [
        "--cap-drop=ALL"
        "--security-opt=no-new-privileges"
        "--memory=512m"
      ];
    };

    systemd.services."${config.virtualisation.oci-containers.backend}-briar-mailbox" = {
      requires = [ "briar-mailbox-image.service" ];
      after = [ "briar-mailbox-image.service" ];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/briar-mailbox 0700 root root -"
      "d /var/lib/briar-mailbox/.local/share 0700 root root -"
    ];

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        {
          directory = "/var/lib/briar-mailbox";
          mode = "0700";
        }
      ];
    };
  };
}

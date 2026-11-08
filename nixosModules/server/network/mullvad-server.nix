{
  config,
  lib,
  pkgs,
  userName,
  ...
}:

{
  options.nixos = {
    server.network.mullvad-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mullvad vpn for server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.mullvad-server.enable {
    sops.secrets."mullvad" = {
      owner = config.users.users.${userName}.name;
      group = config.users.users.${userName}.group;
      mode = "0440";
    };

    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad;
      enableExcludeWrapper = false;
      enableEarlyBootBlocking = false;
    };

    systemd.services.mullvad-setup = {
      description = "Mullvad VPN Setup";
      wantedBy = [ "multi-user.target" ];
      after = [ "mullvad-daemon.service" ];
      requires = [ "mullvad-daemon.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "mullvad-setup" ''
          until ${pkgs.mullvad}/bin/mullvad status > /dev/null 2>&1; do
            sleep 1
          done

          # Every login registers a new device, the account allows five. The first line is printed
          # even if the API is unreachable, a pipe into grep -q would kill mullvad with SIGPIPE.
          ACCOUNT=$(${pkgs.mullvad}/bin/mullvad account get 2>&1 || true)
          # A revoked device still prints "Mullvad account:", only these two states need a new login.
          if [[ $ACCOUNT == *"Not logged in"* || $ACCOUNT == *"has been revoked"* ]]; then
            ${pkgs.mullvad}/bin/mullvad account logout > /dev/null 2>&1 || true
            ${pkgs.mullvad}/bin/mullvad account login $(tr -d '[:space:]' < ${
              config.sops.secrets."mullvad".path
            })
          fi

          ${pkgs.mullvad}/bin/mullvad lan set allow
          # Without IPv6 in the tunnel Mullvad refuses connections to IPv6 addresses, downloads of
          # Ollama from Cloudflare failed with "connection refused".
          ${pkgs.mullvad}/bin/mullvad tunnel set ipv6 on
          ${pkgs.mullvad}/bin/mullvad lockdown-mode set on
          ${pkgs.mullvad}/bin/mullvad dns set custom 127.0.0.1
          ${pkgs.mullvad}/bin/mullvad auto-connect set on
          ${pkgs.mullvad}/bin/mullvad connect
        '';
      };
    };

    # device.json identifies this device, without it every boot starts logged out.
    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/etc/mullvad-vpn"
      ];
    };
  };
}

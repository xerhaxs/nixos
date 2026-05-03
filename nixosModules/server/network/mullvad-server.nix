{
  config,
  lib,
  pkgs,
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

          if ! ${pkgs.mullvad}/bin/mullvad account get 2>&1 | grep -q "Mullvad account:"; then
            ${pkgs.mullvad}/bin/mullvad account login $(tr -d '[:space:]' < ${
              config.sops.secrets."mullvad".path
            })
          fi

          ${pkgs.mullvad}/bin/mullvad lan set allow
          ${pkgs.mullvad}/bin/mullvad lockdown-mode set on
          ${pkgs.mullvad}/bin/mullvad dns set custom 127.0.0.1
          ${pkgs.mullvad}/bin/mullvad auto-connect set on
          ${pkgs.mullvad}/bin/mullvad connect
        '';
      };
    };
  };
}

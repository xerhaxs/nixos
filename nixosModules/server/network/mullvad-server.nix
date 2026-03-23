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
      enableExcludeWrapper = true;
    };

    systemd.services.mullvad-setup = {
      description = "Mullvad VPN Setup";
      wantedBy = [ "multi-user.target" ];
      after = [
        "mullvad-daemon.service"
      ];
      requires = [
        "mullvad-daemon.service"
      ];
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "mullvad-setup" ''
          until ${pkgs.mullvad}/bin/mullvad status > /dev/null 2>&1; do
            sleep 1
          done

          ${pkgs.mullvad}/bin/mullvad account login $(tr -d '[:space:]' < ${
            config.sops.secrets."mullvad".path
          })

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

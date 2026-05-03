{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.vpn.mullvad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mullvad.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.vpn.mullvad.enable {
    programs.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
      settings = {
        preferredLocale = "system";
        autoConnect = false;
        enableSystemNotifications = true;
        monochromaticIcon = true;
        startMinimized = true;
        unpinnedWindow = true;
        browsedForSplitTunnelingApplications = [ ];
        changelogDisplayedForVersion = "";
        updateDismissedForVersion = "";
        animateMap = true;
      };
    };

    home.activation.mullvadSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      TIMEOUT=30
      COUNT=0
      until ${pkgs.mullvad}/bin/mullvad status > /dev/null 2>&1; do
        if [ $COUNT -ge $TIMEOUT ]; then
          echo "Mullvad daemon not available, skipping setup"
          exit 0
        fi
        COUNT=$((COUNT + 1))
        sleep 1
      done

      if ! ${pkgs.mullvad}/bin/mullvad account get 2>&1 | grep -q "Mullvad account:"; then
        ${pkgs.mullvad}/bin/mullvad account login $(tr -d '[:space:]' < ${
          config.sops.secrets."mullvad".path
        }) || true
      fi

      ${pkgs.mullvad}/bin/mullvad lan set allow || true
    '';
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/Mullvad VPN"
      ];
    };
  };
}

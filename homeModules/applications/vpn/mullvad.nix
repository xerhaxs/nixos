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

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/Mullvad VPN"
      ];
    };
  };
}

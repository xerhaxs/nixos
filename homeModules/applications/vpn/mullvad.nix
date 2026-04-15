{
  config,
  lib,
  pkgs,
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
        preferredLocale = "SYSTEM_PREFERRED_LOCALE_KEY";
        autoConnect = true;
        enableSystemNotifications = true;
        monochromaticIcon = false;
        startMinimized = false;
        unpinnedWindow = true;
        browsedForSplitTunnelingApplications = [ ];
        changelogDisplayedForVersion = "";
        updateDismissedForVersion = "";
        animateMap = true;
      };
    };
  };
}

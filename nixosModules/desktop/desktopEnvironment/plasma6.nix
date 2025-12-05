{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.plasma6 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Plasma6 desktop environment.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.plasma6.enable {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };

    qt = {
      enable = true;
      platformTheme = "kde";
    };

    programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;

    environment = {
      plasma6.excludePackages = with pkgs; with kdePackages; [
        elisa
        spectacle
        kwalletmanager
        breeze
        breeze-icons
        breeze-gtk
        oxygen
        oxygen-icons
        oxygen-sounds
        plasma-workspace-wallpapers
        plasma-welcome
      ];

      systemPackages = with pkgs; with kdePackages; [
        kaccounts-providers
        kaccounts-integration
        plasma-browser-integration
        plasma-pa
        plasma-nm
        plasma-disks
        plasma5support
        plasma-desktop
        plasma-activities
        plasma-thunderbolt
        plasma-integration
        plasma-systemmonitor
        plasma-activities-stats
        plasma-wayland-protocols
        print-manager
        libplasma
        systemsettings
        powerdevil
        kpipewire
        konsole
        bluedevil
        kdeplasma-addons
        kaccounts-integration
        akonadi
        akonadi-calendar-tools
        filelight
        maliit-keyboard
        libksysguard
        merkuro
        kate
        colord-kde
        #wallpaper-engine-plugin
        #linux-wallpaperengine
      ];
    };
  };
}

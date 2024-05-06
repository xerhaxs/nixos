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
        oxygen-icons5
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
        partitionmanager
        plasma5support
        plasma-desktop
        plasma-activities
        plasma-thunderbolt
        plasma-integration
        plasma-systemmonitor
        plasma-activities-stats
        plasma-wayland-protocols
        libplasma
        systemsettings
        powerdevil
        kpipewire
        bluedevil
        kdeplasma-addons
        kaccounts-integration
        akonadi
        filelight
        maliit-keyboard
        soundkonverter
        libksysguard
        merkuro
        kate
        colord-kde
      ];
    };
  };
}

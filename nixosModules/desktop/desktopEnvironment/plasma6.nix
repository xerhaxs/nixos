{
  config,
  lib,
  pkgs,
  ...
}:

let
  spectacleOverlay = self: super: {
    kdePackages = super.kdePackages // {
      spectacle = super.kdePackages.spectacle.overrideAttrs (oldAttrs: rec {
        nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [ super.makeWrapper ];
        postInstall = ''
          wrapProgram $out/bin/spectacle \
            --prefix PATH : ${
              super.tesseract5.override {
                enableLanguages = [
                  "eng"
                  "osd"
                  "deu"
                ];
              }
            }/bin \
            --set TESSDATA_PREFIX ${
              super.tesseract5.override {
                enableLanguages = [
                  "eng"
                  "osd"
                  "deu"
                ];
              }
            }/share/tessdata \
            --prefix LD_LIBRARY_PATH : ${
              super.tesseract5.override {
                enableLanguages = [
                  "eng"
                  "osd"
                  "deu"
                ];
              }
            }/lib
        '';
      });
    };
  };
in

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
    nixpkgs.overlays = [ spectacleOverlay ];

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
      plasma6.excludePackages =
        with pkgs;
        with kdePackages;
        [
          breeze
          breeze-gtk
          breeze-icons
          elisa
          kwalletmanager
          oxygen
          oxygen-icons
          oxygen-sounds
          plasma-welcome
          plasma-workspace-wallpapers
        ];

      systemPackages =
        with pkgs;
        with kdePackages;
        [
          akonadi
          akonadi-calendar-tools
          bluedevil
          colord-kde
          filelight
          kaccounts-integration
          kaccounts-integration
          kaccounts-providers
          kate
          kdeplasma-addons
          konsole
          kpeople
          kpipewire
          libplasma
          merkuro
          plasma-activities
          plasma-activities-stats
          plasma-browser-integration
          plasma-desktop
          plasma-disks
          plasma-integration
          plasma-keyboard
          plasma-nm
          plasma-pa
          plasma-systemmonitor
          plasma-thunderbolt
          plasma-wayland-protocols
          plasma5support
          powerdevil
          print-manager
          spectacle
          systemsettings
          #wallpaper-engine-plugin
        ];
    };
  };
}

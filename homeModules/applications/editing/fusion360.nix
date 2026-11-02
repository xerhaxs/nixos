{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  prefix = "${config.xdg.dataHome}/fusion360/wineprefix";
  wine = pkgs.wineWow64Packages.stagingFull;

  # Steps of https://codeberg.org/cryinkfly/Autodesk-Fusion-360-on-Linux with the wine and winetricks of nixpkgs.
  install = pkgs.writeShellApplication {
    name = "fusion360-install";
    runtimeInputs = [
      wine
      pkgs.winetricks
      pkgs.curl
      pkgs.cabextract
      pkgs.p7zip
    ];
    text = ''
      export WINEPREFIX=${lib.escapeShellArg prefix}
      export WINEARCH=win64
      # Wine would add menu entries that cannot find wine, the launcher below replaces them.
      export WINEDLLOVERRIDES=winemenubuilder.exe=d
      # winetricks looks for wine64, which this wine does not ship, and then runs nothing.
      export WINE64=${wine}/bin/wine
      downloads="$WINEPREFIX/drive_c/users/$USER/Downloads"
      mkdir -p "$WINEPREFIX"

      wineboot --init
      wineserver --wait
      winetricks -q sandbox
      winetricks -q atmlib gdiplus arial corefonts cjkfonts dotnet452 msxml4 msxml6 vcrun2017 fontsmooth=rgb winhttp win10
      winetricks -q win10

      reg() { wine REG ADD 'HKCU\Software\Wine\DllOverrides' /v "$1" /t REG_SZ /d "$2" /f; }
      reg adpclientservice.exe ""
      reg AdCefWebBrowser.exe builtin
      reg msvcp140 native
      reg mfc140u native
      reg bcp47langs ""

      winetricks -q dxvk
      reg d3d10core native
      reg d3d11 native
      reg d3d9 builtin
      reg dxgi native

      mkdir -p "$downloads"
      curl -fL -o "$downloads/WebView2installer.exe" \
        "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/76eb3dc4-7851-45b7-a392-460523b0e2bb/MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
      wine "$downloads/WebView2installer.exe" /silent /install

      curl -fL -o "$downloads/FusionClientInstaller.exe" \
        "https://dl.appstreaming.autodesk.com/production/installers/Fusion%20Admin%20Install.exe"
      wine "$downloads/FusionClientInstaller.exe" --quiet
      wine "$downloads/FusionClientInstaller.exe" --quiet
      echo "Fusion 360 installed, start it with fusion360."
    '';
  };

  launcher = pkgs.writeShellApplication {
    name = "fusion360";
    runtimeInputs = [
      wine
      pkgs.findutils
    ];
    text = ''
      export WINEPREFIX=${lib.escapeShellArg prefix}
      exe="$(find "$WINEPREFIX/drive_c" -name Fusion360.exe -ipath '*production*' -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)"
      if [ -z "$exe" ]; then
        echo "Fusion 360 is not installed, run fusion360-install first." >&2
        exit 1
      fi
      exec wine "$exe" "$@"
    '';
  };

  identityManager = pkgs.writeShellApplication {
    name = "fusion360-identity";
    runtimeInputs = [
      wine
      pkgs.findutils
    ];
    text = ''
      export WINEPREFIX=${lib.escapeShellArg prefix}
      exec wine "$(find "$WINEPREFIX/drive_c" -name AdskIdentityManager.exe | head -1)" "$@"
    '';
  };
in

{
  options.homeManager = {
    applications.editing.fusion360 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Autodesk Fusion 360 through wine (fusion360-install sets up the prefix, needs internet and an Autodesk account).";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.fusion360.enable {
    home.packages = [
      identityManager
      install
      launcher
    ];

    xdg.desktopEntries = {
      fusion360 = {
        name = "Autodesk Fusion 360";
        exec = "fusion360";
        icon = "applications-engineering";
        categories = [
          "Graphics"
          "Engineering"
        ];
      };

      # The login in the browser returns through the adskidmgr:// scheme.
      fusion360-identity = {
        name = "Autodesk Identity Manager";
        exec = "fusion360-identity %u";
        noDisplay = true;
        mimeType = [ "x-scheme-handler/adskidmgr" ];
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/fusion360"
      ];
    };
  };
}

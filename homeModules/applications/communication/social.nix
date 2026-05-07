{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.communication.social = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable social communication apps.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.social.enable {
    home.packages = with pkgs; [
      briar-desktop
      element-desktop
      mumble
      signal-desktop
      telegram-desktop
      (karere.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
        postInstall = (old.postInstall or "") + ''
                  wrapProgram $out/bin/karere \
          --set WAYLAND_DISPLAY "" \
          --prefix GST_PLUGIN_PATH : "${
            lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
            ]
          }"
        '';
      }))
    ];

    home.activation.elementElectronConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="$HOME/.config/Element/electron-config.json"
      if [ -f "$CONFIG" ]; then
        ${pkgs.jq}/bin/jq '
          .warnBeforeExit              = false |
          .minimizeToTray              = false |
          .spellCheckerEnabled         = true  |
          .autoHideMenuBar             = false |
          .disableHardwareAcceleration = false |
          .enableContentProtection     = false |
          .openAtLoginMinimised        = false |
          .safeStorageBackend          = "kwallet6" |
          .locale                      = ["en"]
        ' "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".briar"
        ".config/Element"
        ".config/Mumble"
        ".local/share/Mumble"
        ".config/Signal"
        ".local/share/karere"
        ".local/share/TelegramDesktop"
      ];
    };
  };
}

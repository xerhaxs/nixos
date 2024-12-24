{ config, lib, pkgs, ... }:

let
  preferToLower = lib.strings.toLower "${config.nixos.theme.catppuccin.prefer}";
in

{
  options.nixos = {
    base.tools.keepassxc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable keepassxc and change the default settings.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.keepassxc.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];

    systemd.services.keepassxcConfigChecker = {
      description = "Check and create Keepassxc config if not present";

      script = ''
        if [ ! -f ${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/keepassxc/keepassxc.ini ]; then
          mkdir -p ${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/keepassxc
          echo "
            [General]
            BackupBeforeSave=true
            ConfigVersion=2
            MinimizeAfterUnlock=false

            [Browser]
            AllowExpiredCredentials=true
            Browser_AllowLocalhostWithPasskeys=true
            CustomProxyLocation=
            Enabled=true
            SearchInAllDatabases=true

            [GUI]
            ApplicationTheme=classic
            MinimizeOnClose=true
            MinimizeOnStartup=true
            MinimizeToTray=true
            ShowTrayIcon=true
            TrayIconAppearance=monochrome-${preferToLower}

            [PasswordGenerator]
            AdditionalChars=
            AdvancedMode=true
            ExcludedChars=
            Length=128
            Logograms=true

            [Security]
            ClearSearch=true
            HideTotpPreviewPanel=true
            IconDownloadFallback=true
            LockDatabaseIdle=false
            LockDatabaseIdleSeconds=900
          " > ${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/keepassxc/keepassxc.ini
        fi

        chown -R ${config.nixos.system.user.defaultuser.name}:users ${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/
        chown -R ${config.nixos.system.user.defaultuser.name}:users ${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}/.config/keepassxc
      '';

      wantedBy = [ "multi-user.target" ];
    };
  };
}
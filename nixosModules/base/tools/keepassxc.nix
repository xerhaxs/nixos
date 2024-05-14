{ config, lib, pkgs, ... }:

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

    systemd.services.keepassxc.preStart = ''
      if [ ! -f $HOME/.config/keepassxc/keepassxc.ini ]; then
        mkdir -p $HOME/.config/keepassxc
        echo "
          [General]
          ConfigVersion=2
          MinimizeAfterUnlock=false

          [Browser]
          AllowExpiredCredentials=true
          CustomProxyLocation=
          Enabled=true
          SearchInAllDatabases=true

          [GUI]
          ApplicationTheme=classic
          MinimizeOnClose=true
          MinimizeOnStartup=true
          MinimizeToTray=true
          ShowTrayIcon=true
          TrayIconAppearance=monochrome-light

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
        " > $HOME/.config/keepassxc/keepassxc.ini
      fi
    '';
  };
}
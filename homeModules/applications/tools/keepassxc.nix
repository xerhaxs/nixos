{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  # git-credential-keepassxc reads entries from the unlocked database through the browser
  # integration, KeePassXC asks before the first access. The association lives in this file.
  credConfig = "${config.xdg.configHome}/git-credential-keepassxc/config.json";
  kpxcCred = pkgs.writeShellScriptBin "kpxc-cred" ''
    exec ${pkgs.git-credential-keepassxc}/bin/git-credential-keepassxc --config "${credConfig}" "$@"
  '';

  # sops asks for the admin age key only while editing, the key is the password of the entry with
  # the URL https://sops-admin.invalid. No copy of it on disk.
  sopsAgeKey = pkgs.writeShellScript "sops-age-key" ''
    printf 'protocol=https\nhost=sops-admin.invalid\n\n' \
      | ${kpxcCred}/bin/kpxc-cred --unlock 3 get \
      | ${pkgs.gnused}/bin/sed -n 's/^password=//p'
  '';
in

{
  options.homeManager = {
    applications.tools.keepassxc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable keepassxc";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.tools.keepassxc.enable {
    programs.keepassxc = {
      enable = true;
      autostart = false;
      settings = {
        General = {
          SingleInstance = true;
          RememberLastDatabases = true;
          NumberOfRememberedLastDatabases = 5;
          RememberLastKeyFiles = true;
          OpenPreviousDatabasesOnStartup = true;
          AutoSaveAfterEveryChange = true;
          AutoReloadOnChange = true;
          AutoSaveOnExit = true;
          AutoSaveNonDataChanges = true;
          BackupBeforeSave = true;
          BackupFilePathPattern = "{DB_FILENAME}.old.kdbx";
          UseAtomicSaves = true;
          UseDirectWriteSaves = false;
          SearchLimitGroup = false;
          MinimizeOnOpenUrl = false;
          OpenURLOnDoubleClick = true;
          URLDoubleClickAction = 0;
          HideWindowOnCopy = false;
          MinimizeOnCopy = false;
          AutoGeneratePasswordForNewEntries = false;
          MinimizeAfterUnlock = false;
          DropToBackgroundOnCopy = false;
          UseGroupIconOnEntryCreation = true;
          AutoTypeEntryTitleMatch = true;
          AutoTypeEntryURLMatch = true;
          # VNC viewers (remote-viewer) drop keystrokes and releases of Shift at 25 ms.
          AutoTypeDelay = 150;
          AutoTypeStartDelay = 500;
          AutoTypeHideExpiredEntry = false;
          AutoTypeDialogSortColumn = 0;
          AutoTypeDialogSortOrder = "AscendingOrder";
          GlobalAutoTypeKey = 0;
          GlobalAutoTypeModifiers = 0;
          GlobalAutoTypeRetypeTime = 0;
          FaviconDownloadTimeout = 10;
          UpdateCheckMessageShown = false;
        };

        GUI = {
          Language = "system";
          HideMenubar = false;
          HideToolbar = false;
          MovableToolbar = false;
          HideGroupPanel = false;
          HidePreviewPanel = false;
          GUI_AlwaysOnTop = false;
          ToolButtonStyle = "ToolButtonIconOnly";
          LaunchAtStartup = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
          MinimizeToTray = true;
          MinimizeOnStartup = true;
          MinimizeOnClose = true;
          HideUsernames = false;
          HidePasswords = true;
          ColorPasswords = false;
          MonospaceNotes = false;
          ApplicationTheme = "classic";
          CompactMode = false;
          CheckForUpdates = false;
          CheckForUpdatesNextCheck = 0;
          CheckForUpdatesIncludeBetas = false;
          SearchWaitForEnter = false;
          ShowExpiredEntriesOnDatabaseUnlock = true;
          ShowExpiredEntriesOnDatabaseUnlockOffsetDays = 3;
          FontSizeOffset = 0;
        };

        Security = {
          ClearClipboard = true;
          ClearClipboardTimeout = 10;
          ClearSearch = true;
          ClearSearchTimeout = 10;
          Security_HideNotes = false;
          LockDatabaseIdle = false;
          LockDatabaseIdleSeconds = 900;
          LockDatabaseMinimize = false;
          LockDatabaseScreenLock = true;
          LockDatabaseOnUserSwitch = true;
          RelockAutoType = false;
          PasswordsHidden = true;
          PasswordEmptyPlaceholder = false;
          HidePasswordPreviewPanel = true;
          HideTotpPreviewPanel = true;
          AutotypeAsk = true;
          AutoTypeSkipMainWindowConfirmation = false;
          IconDownloadFallback = true;
          NoConfirmMoveEntryToRecycleBin = false;
          EnableCopyOnDoubleClick = false;
          QuickUnlock = false;
          DatabasePasswordMinimumQuality = 0;
        };

        Browser = {
          Enabled = true;
          ShowNotification = true;
          BestMatchOnly = false;
          UnlockDatabase = true;
          MatchUrlScheme = true;
          SupportBrowserProxy = true;
          UseCustomProxy = false;
          UpdateBinaryPath = false;
          AllowGetDatabaseEntriesRequest = false;
          AllowExpiredCredentials = false;
          AlwaysAllowAccess = false;
          AlwaysAllowUpdate = false;
          HttpAuthPermission = false;
          SearchInAllDatabases = true;
          SupportKphFields = true;
          NoMigrationPrompt = false;
          UseCustomBrowser = false;
          CustomBrowserType = "-1";
          CustomBrowserLocation = "";
          AllowLocalhostWithPasskeys = true;
        };

        SSHAgent = {
          Enabled = true;
          UseOpenSSH = true;
          UsePageant = false;
        };

        FdoSecrets = {
          Enabled = false;
          ShowNotification = true;
          ConfirmDeleteItem = true;
          ConfirmAccessItem = true;
          UnlockBeforeSearch = true;
        };

        KeeShare = {
          QuietSuccess = false;
        };

        PasswordGenerator = {
          LowerCase = true;
          UpperCase = true;
          Numbers = true;
          EASCII = true;
          AdvancedMode = true;
          SpecialChars = true;
          Braces = true;
          Punctuation = true;
          Quotes = true;
          Dashes = true;
          Math = true;
          Logograms = true;
          ExcludeAlike = true;
          EnsureEvery = true;
          Length = 128;
          WordCount = 12;
          WordSeparator = " ";
          WordList = "eff_large.wordlist";
          WordCase = 0;
          Type = 0;
        };

        Messages = {
          NoLegacyKeyFileWarning = false;
        };
      };
    };

    # KeePassXC adds the SSH keys of the unlocked database to this agent and removes them when it locks.
    services.ssh-agent.enable = true;
    systemd.user.sessionVariables.SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/ssh-agent";

    # sops takes the admin age key from KeePassXC (setup: kpxc-cred configure, see TODO 7A).
    home.packages = [ kpxcCred ];
    home.sessionVariables.SOPS_AGE_KEY_CMD = "${sopsAgeKey}";
    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [ ".config/git-credential-keepassxc" ];
    };

    programs.plasma.startup.startupScript."keepassxc" = {
      text = ''
        sleep 5
        ${pkgs.keepassxc}/bin/keepassxc &
      '';
      runAlways = true;
      priority = 8;
    };
  };
}

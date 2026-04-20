{
  config,
  lib,
  pkgs,
  ...
}:

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
      autostart = true;
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
          AutoTypeDelay = 25;
          AutoTypeStartDelay = 500;
          AutoTypeHideExpiredEntry = false;
          AutoTypeDialogSortColumn = 0;
          AutoTypeDialogSortOrder = "AscendingOrder";
          GlobalAutoTypeKey = 0;
          GlobalAutoTypeModifiers = 0;
          GlobalAutoTypeRetypeTime = 0;
          FaviconDownloadTimeout = 10;
          UpdateCheckMessageShown = false;
          #DefaultDatabaseFileName = "";
          #LastDatabases = "";
          #LastKeyFiles = "";
          #LastChallengeResponse = "";
          #LastActiveDatabase = "";
          #LastOpenedDatabases = "";
          #LastDir = "";
        };

        GUI = {
          Language = "system";
          HideMenubar = false;
          HideToolbar = false;
          MovableToolbar = false;
          HideGroupPanel = false;
          HidePreviewPanel = false;
          AlwaysOnTop = false;
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
          #MainWindowGeometry = "";
          #MainWindowState = "";
          #ListViewState = "";
          #SearchViewState = "";
          #SplitterState = "";
          #GroupSplitterState = "";
          #PreviewSplitterState = "";
          #AutoTypeSelectDialogSize = "";
        };

        Security = {
          ClearClipboard = true;
          ClearClipboardTimeout = 10;
          ClearSearch = true;
          ClearSearchTimeout = 10;
          HideNotes = false;
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
          AutoTypeAsk = true;
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
          #CustomProxyLocation = "";
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
          Enable = true;
          UseOpenSSH = true;
          UsePageant = false;
          #AuthSockOverride = "";
          #SecurityKeyProviderOverride = "";
        };

        FdoSecrets = {
          Enable = false;
          ShowNotification = true;
          ConfirmDeleteItem = true;
          ConfirmAccessItem = true;
          UnlockBeforeSearch = true;
        };

        KeeShare = {
          QuietSuccess = false;
          #Own = "";
          #Foreign = "";
          #Active = "";
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
          #AdditionalChars = "";
          #ExcludedChars = "";
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
          #HidePreReleaseWarning = "";
        };
      };
    };
  };
}

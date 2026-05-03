{
  config,
  lib,
  pkgs,
  osConfig,
  plasma-manager,
  userName,
  ...
}:

{
  # Option Search https://nix-community.github.io/plasma-manager/options.xhtml
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  options.homeManager = {
    desktop.desktopEnvironment.plasma6.plasma6 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable plasma6.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.plasma6.plasma6.enable {
    programs.elisa.enable = false;
    programs.ghostwriter.enable = false;
    programs.kate.enable = false;
    programs.konsole.enable = false;
    programs.okular.enable = false;

    programs.plasma = {
      enable = true;
      overrideConfig = true;

      workspace = {
        clickItemTo = "select";
        tooltipDelay = 30;
        wallpaper = "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/52338778943_9704c200b4_o.jpg";
      };

      windows = {
        allowWindowsToRememberPositions = true;
      };

      startup = {

      };

      powerdevil = {
        general = {
          pausePlayersOnSuspend = true;
        };

        AC = {
          powerProfile = "balanced";
          autoSuspend = {
            action = "nothing";
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 900;
          };
          dimKeyboard = {
            enable = true;
          };
          turnOffDisplay = {
            idleTimeout = "never";
          };
          whenLaptopLidClosed = "sleep";
          whenSleepingEnter = "standby";
          displayBrightness = 75;
          inhibitLidActionWhenExternalMonitorConnected = true;
          keyboardBrightness = 100;
          powerButtonAction = "shutDown";
        };

        battery = {
          powerProfile = "powerSaving";
          autoSuspend = {
            action = "sleep";
            idleTimeout = 600;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 60;
          };
          dimKeyboard = {
            enable = true;
          };
          turnOffDisplay = {
            idleTimeout = 120;
            idleTimeoutWhenLocked = 60;
          };
          whenLaptopLidClosed = "sleep";
          whenSleepingEnter = "standby";
          displayBrightness = 50;
          inhibitLidActionWhenExternalMonitorConnected = true;
          keyboardBrightness = 50;
          powerButtonAction = "shutDown";
        };

        batteryLevels = {
          lowLevel = 30;
          criticalAction = "sleep";
          criticalLevel = 5;
        };

        lowBattery = {
          powerProfile = "powerSaving";
          autoSuspend = {
            action = "sleep";
            idleTimeout = 300;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 30;
          };
          dimKeyboard = {
            enable = true;
          };
          turnOffDisplay = {
            idleTimeout = 60;
            idleTimeoutWhenLocked = 20;
          };
          whenLaptopLidClosed = "sleep";
          whenSleepingEnter = "standby";
          displayBrightness = 10;
          inhibitLidActionWhenExternalMonitorConnected = true;
          keyboardBrightness = 25;
          powerButtonAction = "shutDown";
        };
      };

      session = {
        general = {
          askForConfirmationOnLogout = false;
        };

        sessionRestore = {
          restoreOpenApplicationsOnLogin = "startWithEmptySession";
        };
      };

      kwin = {
        titlebarButtons.right = [
          "minimize"
          "maximize"
          "close"
        ];
        titlebarButtons.left = [
          "keep-above-windows"
        ];

        effects = {
          desktopSwitching.animation = "fade";
          translucency.enable = true;
          blur.enable = true;
          dimAdminMode.enable = true;
        };

        virtualDesktops = {
          rows = 2;
          names = [
            "Desktop 1"
            "Desktop 2"
            "Desktop 3"
            "Desktop 4"
          ];
          number = 4;
        };
      };

      hotkeys.commands."launch-kitty" = {
        name = "Launch Kitty";
        key = "Meta+Return";
        command = "kitty";
      };

      panels = [
        {
          location = "top";
          alignment = "center";
          lengthMode = "fill";
          height = 48;
          hiding = "none";
          floating = true;

          widgets = [
            # We can configure the widgets by adding the name and config
            # attributes. For example to add the the kickoff widget and set the
            # icon to "nix-snowflake-white" use the below configuration. This will
            # add the "icon" key to the "General" group for the widget in
            # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
            {
              name = "org.kde.plasma.kickoff";
              config = {
                General = {
                  icon = "nix-snowflake-white";
                  favoritesPortedToKAstats = "true";
                  systemFavorites = "suspend\\,reboot\\,shutdown"; # no hibernation "suspend\\,hibernate\\,reboot\\,shutdown"
                };
              };
            }

            {
              name = "org.kde.plasma.trash";
            }

            {
              name = "org.kde.plasma.notes";
              config = {
                General = {
                  color = "translucent-light";
                  fontSize = "12";
                };
              };
            }

            {
              name = "org.kde.plasma.colorpicker";
            }

            "org.kde.plasma.panelspacer"

            {
              name = "org.kde.plasma.icontasks";
              config = {
                General.launchers = [
                  "applications:virt-manager.desktop"
                  "applications:qalculate-gtk.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:librewolf.desktop"
                  "applications:torbrowser.desktop"
                  "applications:thunderbird.desktop"
                  "applications:org.kde.kate.desktop"
                  "applications:codium.desktop"
                  "applications:signal.desktop"
                  "applications:org.telegram.desktop.desktop"
                  "applications:com.github.xeco23.WasIstLos.desktop"
                  "applications:legcord.desktop"
                  "applications:org.kde.kmymoney.desktop"
                  "applications:org.kde.kile.desktop"
                  "applications:writer.desktop"
                  "applications:calc.desktop"
                  "applications:impress.desktop"
                  "applications:com.github.flxzt.rnote.desktop"
                  "applications:com.obsproject.Studio.desktop"
                  #"applications:blender.desktop"
                  #"applications:com.ultimaker.cura.desktop"
                  "applications:org.clementine_player.Clementine.desktop"
                  #"applications:fluent-reader.desktop"
                  "applications:freetube.desktop"
                ]
                ++ lib.optionals osConfig.nixos.userEnvironment.game.enable [
                  "applications:org.prismlauncher.PrismLauncher.desktop"
                  "applications:com.heroicgameslauncher.hgl.desktop"
                  "applications:steam.desktop"
                ]
                ++ lib.optionals config.homeManager.applications.vpn.enable [
                  "applications:mullvad-vpn.desktop"
                  #"applications:protonvpn-app.desktop"
                ];
              };
            }

            "org.kde.plasma.panelspacer"

            {
              name = "org.kde.plasma.systemtray";
              config = {
                General = {
                  hiddenItems = "KDE Connect Indicator,org.kde.plasma.clipboard,org.kde.plasma.mediacontroller,org.kde.plasma.weather,org.kde.merkuro.contact.applet,org.kde.plasma.brightness,Easy Effects,Discover Notifier_org.kde.DiscoverNotifier";
                  shownItems = "org.kde.plasma.battery,org.kde.plasma.networkmanagement";
                };
              };
            }

            {
              name = "org.kde.plasma.digitalclock";
              config = {
                Appearance = {
                  dateFormat = "isoDate";
                  enabledCalendarPlugins = "alternatecalendar,astronomicalevents,holidaysevents";
                  showSeconds = "Always";
                  showWeekNumbers = "true";
                  use24hFormat = "2";
                };
              };
            }
          ];
        }
      ];

      #
      # Some mid-level settings:
      #
      #shortcuts = {
      #  kwin = {
      #    "Expose" = "Meta+,";
      #    "Switch Window Down" = "Meta+J";
      #    "Switch Window Left" = "Meta+H";
      #    "Switch Window Right" = "Meta+L";
      #    "Switch Window Up" = "Meta+K";
      #  };
      #};

      #
      # Some low-level settings:
      #

      shortcuts = {
        "Clementine" = {
          "next_album" = "Shift+Media Next";
          "next_track" = [ ];
          "play_pause" = [ ];
          "prev_track" = [ ];
          "stop" = [ ];
        };

        "KDE Keyboard Layout Switcher" = {
          "Switch keyboard layout to German" = [ ];
          "Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
          "Switch to Next Keyboard Layout" = "Meta+Alt+K";
        };

        "kaccess" = {
          "Toggle Screen Reader On and Off" = "Meta+Alt+S";
        };

        "kcm_touchpad" = {
          "Disable Touchpad" = "Touchpad Off";
          "Enable Touchpad" = "Touchpad On";
          "Toggle Touchpad" = [
            "Touchpad Toggle"
            "Meta+Ctrl+Zenkaku Hankaku"
          ];
        };

        "kmix" = {
          "decrease_microphone_volume" = "Microphone Volume Down";
          "decrease_volume" = "Volume Down";
          "decrease_volume_small" = "Shift+Volume Down";
          "increase_microphone_volume" = "Microphone Volume Up";
          "increase_volume" = "Volume Up";
          "increase_volume_small" = "Shift+Volume Up";
          "mic_mute" = [
            "Meta+Alt+-"
            "Microphone Mute"
            "Meta+Volume Mute"
          ];
          "mute" = "Volume Mute";
        };

        "ksmserver" = {
          "Halt Without Confirmation" = [ ];
          "Lock Session" = [
            "Meta+L"
            "Screensaver"
          ];
          "Log Out" = "Ctrl+Alt+Del";
          "Log Out Without Confirmation" = "Meta+Shift+Q";
          "Reboot" = [ ];
          "Reboot Without Confirmation" = "Meta+Shift+R";
          "Shut Down" = [ ];
        };

        "kwin" = {
          "Activate Window Demanding Attention" = "Meta+Ctrl+A";
          "Cycle Overview" = [ ];
          "Cycle Overview Opposite" = [ ];
          "Decrease Opacity" = [ ];
          "Edit Tiles" = "Meta+T";
          "Expose" = "Ctrl+F9";
          "ExposeAll" = [
            "Ctrl+F10"
            "Launch (C)"
          ];
          "ExposeClass" = "Ctrl+F7";
          "ExposeClassCurrentDesktop" = [ ];
          "Grid View" = "Meta+G";
          "Increase Opacity" = [ ];
          "Kill Window" = [
            "Meta+Ctrl+Esc"
            "Meta+Ctrl+Q"
          ];
          "Move Tablet to Next Output" = [ ];
          "MoveMouseToCenter" = "Meta+F6";
          "MoveMouseToFocus" = "Meta+F5";
          "MoveZoomDown" = [ ];
          "MoveZoomLeft" = [ ];
          "MoveZoomRight" = [ ];
          "MoveZoomUp" = [ ];
          "Overview" = "Meta+W";
          "Setup Window Shortcut" = [ ];
          "Show Desktop" = "Meta+D";
          "ShowDesktopGrid" = [
            "Meta+F8"
            "Meta+E"
          ];
          "Suspend Compositing" = "Alt+Shift+F12";
          "Switch One Desktop Down" = "Meta+Ctrl+Down";
          "Switch One Desktop Up" = "Meta+Ctrl+Up";
          "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
          "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
          "Switch Window Down" = "Meta+Alt+Down";
          "Switch Window Left" = "Meta+Alt+Left";
          "Switch Window Right" = "Meta+Alt+Right";
          "Switch Window Up" = "Meta+Alt+Up";
          "Switch to Desktop 1" = "Ctrl+F1";
          "Switch to Desktop 2" = "Ctrl+F2";
          "Switch to Desktop 3" = "Ctrl+F3";
          "Switch to Desktop 4" = "Ctrl+F4";
          "Switch to Desktop 5" = [ ];
          "Switch to Desktop 6" = [ ];
          "Switch to Desktop 7" = [ ];
          "Switch to Desktop 8" = [ ];
          "Switch to Desktop 9" = [ ];
          "Switch to Desktop 10" = [ ];
          "Switch to Desktop 11" = [ ];
          "Switch to Desktop 12" = [ ];
          "Switch to Desktop 13" = [ ];
          "Switch to Desktop 14" = [ ];
          "Switch to Desktop 15" = [ ];
          "Switch to Desktop 16" = [ ];
          "Switch to Desktop 17" = [ ];
          "Switch to Desktop 18" = [ ];
          "Switch to Desktop 19" = [ ];
          "Switch to Desktop 20" = [ ];
          "Switch to Next Desktop" = [ ];
          "Switch to Next Screen" = [ ];
          "Switch to Previous Desktop" = [ ];
          "Switch to Previous Screen" = [ ];
          "Switch to Screen 0" = [ ];
          "Switch to Screen 1" = [ ];
          "Switch to Screen 2" = [ ];
          "Switch to Screen 3" = [ ];
          "Switch to Screen 4" = [ ];
          "Switch to Screen 5" = [ ];
          "Switch to Screen 6" = [ ];
          "Switch to Screen 7" = [ ];
          "Switch to Screen Above" = [ ];
          "Switch to Screen Below" = [ ];
          "Switch to Screen to the Left" = [ ];
          "Switch to Screen to the Right" = [ ];
          "Toggle Night Color" = [ ];
          "Toggle Window Raise/Lower" = [ ];
          "Walk Through Desktop List" = [ ];
          "Walk Through Desktop List (Reverse)" = [ ];
          "Walk Through Desktops" = [ ];
          "Walk Through Desktops (Reverse)" = [ ];
          "Walk Through Windows" = "Alt+Tab";
          "Walk Through Windows (Reverse)" = "Alt+Shift+Backtab";
          "Walk Through Windows Alternative" = [ ];
          "Walk Through Windows Alternative (Reverse)" = [ ];
          "Walk Through Windows of Current Application" = "Alt+\`";
          "Walk Through Windows of Current Application (Reverse)" = "Alt+~";
          "Walk Through Windows of Current Application Alternative" = [ ];
          "Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
          "Window Above Other Windows" = [ ];
          "Window Below Other Windows" = [ ];
          "Window Close" = [
            "Alt+F4"
            "Meta+Q"
          ];
          "Window Fullscreen" = [ ];
          "Window Grow Horizontal" = [ ];
          "Window Grow Vertical" = [ ];
          "Window Lower" = [ ];
          "Window Maximize" = "Meta+PgUp";
          "Window Maximize Horizontal" = [ ];
          "Window Maximize Vertical" = [ ];
          "Window Minimize" = "Meta+PgDown";
          "Window Move" = [ ];
          "Window Move Center" = [ ];
          "Window No Border" = [ ];
          "Window On All Desktops" = [ ];
          "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
          "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
          "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
          "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
          "Window One Screen Down" = [ ];
          "Window One Screen Up" = [ ];
          "Window One Screen to the Left" = [ ];
          "Window One Screen to the Right" = [ ];
          "Window Operations Menu" = "Alt+F3";
          "Window Pack Down" = [ ];
          "Window Pack Left" = [ ];
          "Window Pack Right" = [ ];
          "Window Pack Up" = [ ];
          "Window Quick Tile Bottom" = "Meta+Down";
          "Window Quick Tile Bottom Left" = [ ];
          "Window Quick Tile Bottom Right" = [ ];
          "Window Quick Tile Left" = "Meta+Left";
          "Window Quick Tile Right" = "Meta+Right";
          "Window Quick Tile Top" = "Meta+Up";
          "Window Quick Tile Top Left" = [ ];
          "Window Quick Tile Top Right" = [ ];
          "Window Raise" = [ ];
          "Window Resize" = [ ];
          "Window Shade" = [ ];
          "Window Shrink Horizontal" = [ ];
          "Window Shrink Vertical" = [ ];
          "Window to Desktop 1" = [ ];
          "Window to Desktop 2" = [ ];
          "Window to Desktop 3" = [ ];
          "Window to Desktop 4" = [ ];
          "Window to Desktop 5" = [ ];
          "Window to Desktop 6" = [ ];
          "Window to Desktop 7" = [ ];
          "Window to Desktop 8" = [ ];
          "Window to Desktop 9" = [ ];
          "Window to Desktop 10" = [ ];
          "Window to Desktop 11" = [ ];
          "Window to Desktop 12" = [ ];
          "Window to Desktop 13" = [ ];
          "Window to Desktop 14" = [ ];
          "Window to Desktop 15" = [ ];
          "Window to Desktop 16" = [ ];
          "Window to Desktop 17" = [ ];
          "Window to Desktop 18" = [ ];
          "Window to Desktop 19" = [ ];
          "Window to Desktop 20" = [ ];
          "Window to Next Desktop" = [ ];
          "Window to Next Screen" = "Meta+Shift+Right";
          "Window to Previous Desktop" = [ ];
          "Window to Previous Screen" = "Meta+Shift+Left";
          "Window to Screen 0" = [ ];
          "Window to Screen 1" = [ ];
          "Window to Screen 2" = [ ];
          "Window to Screen 3" = [ ];
          "Window to Screen 4" = [ ];
          "Window to Screen 5" = [ ];
          "Window to Screen 6" = [ ];
          "Window to Screen 7" = [ ];
          "view_actual_size" = "Meta+0";
          "view_zoom_in" = [
            "Meta++"
            "Meta+="
          ];
          "view_zoom_out" = "Meta+-";
        };

        "mediacontrol" = {
          "mediavolumedown" = [ ];
          "mediavolumeup" = [ ];
          "nextmedia" = "Media Next";
          "pausemedia" = "Media Pause";
          "playmedia" = [ ];
          "playpausemedia" = "Media Play";
          "previousmedia" = "Media Previous";
          "stopmedia" = "Media Stop";
        };

        "org_kde_powerdevil" = {
          "Decrease Keyboard Brightness" = "Keyboard Brightness Down";
          "Decrease Screen Brightness" = "Monitor Brightness Down";
          "Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
          # "Hibernate" = "Hibernate";
          "Increase Keyboard Brightness" = "Keyboard Brightness Up";
          "Increase Screen Brightness" = "Monitor Brightness Up";
          "Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
          "PowerDown" = "Power Down";
          "PowerOff" = "Power Off";
          "Sleep" = "Sleep";
          "Toggle Keyboard Backlight" = "Keyboard Light On/Off";
          "Turn Off Screen" = [ ];
          "powerProfile" = [
            "Battery"
            "Meta+B"
          ];
        };

        "plasmashell" = {
          "activate task manager entry 1" = "Meta+1";
          "activate task manager entry 2" = "Meta+2";
          "activate task manager entry 3" = "Meta+3";
          "activate task manager entry 4" = "Meta+4";
          "activate task manager entry 5" = "Meta+5";
          "activate task manager entry 6" = "Meta+6";
          "activate task manager entry 7" = "Meta+7";
          "activate task manager entry 8" = "Meta+8";
          "activate task manager entry 9" = "Meta+9";
          "activate task manager entry 10" = [ ];
          "clear-history" = [ ];
          "clipboard_action" = "Meta+Ctrl+X";
          "cycle-panels" = "Meta+Alt+P";
          "cycleNextAction" = [ ];
          "cyclePrevAction" = [ ];
          "edit_clipboard" = [ ];
          "manage activities" = "Meta+A";
          "next activity" = "Meta+Tab";
          "previous activity" = "Meta+Shift+Tab";
          "repeat_action" = "Meta+Ctrl+R";
          "show dashboard" = "Ctrl+F12";
          "show-barcode" = [ ];
          "show-on-mouse-pos" = "Meta+V";
          "stop current activity" = "Meta+S";
          "switch to next activity" = [ ];
          "switch to previous activity" = [ ];
          "toggle do not disturb" = [ ];
        };

        "services/kitty.desktop" = {
          "_launch" = "Meta+Return";
        };

        "services/org.flameshot.Flameshot.desktop" = {
          "Capture" = "Print";
        };

        "services/org.kde.dolphin.desktop" = {
          "_launch" = "Meta+F";
        };

        "services/org.kde.krunner.desktop" = {
          "_launch" = [
            "Meta+R"
            "Meta+Space"
            "Alt+Space"
            "Alt+F2"
            "Search"
          ];
        };

        "services/org.kde.plasma-systemmonitor.desktop" = {
          "_launch" = "Ctrl+Shift+Esc";
        };

        "services/org.kde.spectacle.desktop" = {
          "ActiveWindowScreenShot" = [ ];
          "FullScreenScreenShot" = "Ctrl+Print";
          "RecordRegion" = [ ];
          "RecordScreen" = [ ];
          "RecordWindow" = [ ];
          "RectangularRegionScreenShot" = [ ];
          "WindowUnderCursorScreenShot" = [ ];
          "_launch" = "Meta+Print";
        };
      };

      configFile = {
        "plasmaparc"."General" = {
          "VolumeStep" = 1;
          "AudioFeedback" = false;
        };

        "baloofilerc" = {
          "General" = {
            "dbVersion" = 2;
            "exclude filters" =
              "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
            "exclude filters version" = 8;
            "index hidden folders" = true;
          };
        };

        "kcminputrc" = {
          "Keyboard" = {
            "NumLock" = 0;
          };
          "Libinput.10182.3396.DLL0B38:01 27C6:0D44 Mouse" = {
            "PointerAccelerationProfile" = 1;
          };
          "Libinput.10182.3396.DLL0B38:01 27C6:0D44 Touchpad" = {
            "ClickMethod" = 2;
            "LmrTapButtonMap" = false;
            "NaturalScroll" = true;
            "PointerAccelerationProfile" = 2;
            "ScrollFactor" = 1.5;
            "TapToClick" = true;
          };
          "Libinput.PIXA3854:00 093A:0274 Touchpad" = {
            "NaturalScroll" = true;
            "ScrollFactor" = 2;
          };
          "Libinput/13364/1553/Keychron Keychron Q1 Pro Mouse" = {
            "PointerAccelerationProfile" = 1;
          };
          "Libinput/5426/171/Razer Razer Basilisk V3 Pro" = {
            "PointerAccelerationProfile" = 1;
          };
          "Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad" = {
            "ClickMethod" = 2;
            "LmrTapButtonMap" = false;
            "NaturalScroll" = true;
            "ScrollFactor" = 1.5;
            "TapToClick" = true;
          };
          "Tmp" = {
            "update_info" = "delete_cursor_old_default_size.upd:DeleteCursorOldDefaultSize";
          };
        };

        "kded5rc" = {
          "Module-browserintegrationreminder" = {
            "autoload" = false;
          };
          "Module-device_automounter" = {
            "autoload" = false;
          };
          "PlasmaBrowserIntegration" = {
            "shownCount" = 4;
          };
        };

        "kded6rc" = {
          "PlasmaBrowserIntegration" = {
            "shownCount" = 4;
          };
        };

        "kdeglobals" = {
          "DirSelect Dialog" = {
            "DirSelectDialog Size" = "844,598";
          };
          "General" = {
            "AllowKDEAppsToRememberWindowPositions" = true;
            "BrowserApplication" = "librewolf.desktop";
            "TerminalApplication" = "kitty";
            "TerminalService" = "kitty.desktop";
          };
          "KDE" = {
            "ScrollbarLeftClickNavigatesByPage" = false;
            "ShowDeleteCommand" = true;
          };
          "KFileDialog Settings" = {
            "Allow Expansion" = true;
            "Automatically select filename extension" = true;
            "Breadcrumb Navigation" = true;
            "Decoration position" = 2;
            "LocationCombo Completionmode" = 5;
            "PathCombo Completionmode" = 5;
            "Preview Width" = 0;
            "Show Bookmarks" = true;
            "Show Full Path" = true;
            "Show Inline Previews" = true;
            "Show Preview" = true;
            "Show Speedbar" = true;
            "Show hidden files" = true;
            "Sort by" = "Name";
            "Sort directories first" = true;
            "Sort hidden files last" = false;
            "Sort reversed" = false;
            "Speedbar Width" = 138;
            "View Style" = "DetailTree";
          };
          "PreviewSettings" = {
            "MaximumRemoteSize" = 0;
          };
          # "WM" = {
          #   "activeBackground" = "239,241,245";
          #   "activeBlend" = "76,79,105";
          #   "activeForeground" = "76,79,105";
          #   "inactiveBackground" = "220,224,232";
          #   "inactiveBlend" = "108,111,133";
          #   "inactiveForeground" = "108,111,133";
          # };
        };

        "kglobalshortcutsrc" = {
          "ActivityManager" = {
            "_k_friendly_name" = "Activity Manager";
          };
          "Clementine" = {
            "_k_friendly_name" = "Clementine";
          };
          "KDE Keyboard Layout Switcher" = {
            "_k_friendly_name" = "Keyboard Layout Switcher";
          };
          "kaccess" = {
            "_k_friendly_name" = "Accessibility";
          };
          "kcm_touchpad" = {
            "_k_friendly_name" = "Touchpad";
          };
          "khotkeys" = {
            "_k_friendly_name" = "Custom Shortcuts Service";
          };
          "kmix" = {
            "_k_friendly_name" = "Audio Volume";
          };
          "ksmserver" = {
            "_k_friendly_name" = "Session Management";
          };
          "kwin" = {
            "_k_friendly_name" = "KWin";
          };
          "mediacontrol" = {
            "_k_friendly_name" = "Media Controller";
          };
          "org_kde_powerdevil" = {
            "_k_friendly_name" = "KDE Power Management System";
          };
          "plasmashell" = {
            "_k_friendly_name" = "plasmashell";
          };
        };

        "khotkeysrc" = {
          "Data" = {
            "DataCount" = 3;
          };
          "Data_1" = {
            "Comment" = "KMenuEdit Global Shortcuts";
            "DataCount" = 1;
            "Enabled" = true;
            "Name" = "KMenuEdit";
            "SystemGroup" = 1;
            "Type" = "ACTION_DATA_GROUP";
          };
          "Data_1Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_1_1" = {
            "Comment" = "Comment";
            "Enabled" = true;
            "Name" = "Search";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_1_1Actions" = {
            "ActionsCount" = 1;
          };
          "Data_1_1Actions0" = {
            "CommandURL" = "http://duckduckgo.com";
            "Type" = "COMMAND_URL";
          };
          "Data_1_1Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_1_1Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_1_1Triggers0" = {
            "Key" = "";
            "Type" = "SHORTCUT";
          };
          "Data_2" = {
            "Comment" =
              "This group contains various examples demonstrating most of the features of KHotkeys. (Note that this group and all its actions are disabled by default.)";
            "DataCount" = 8;
            "Enabled" = false;
            "ImportId" = "kde32b1";
            "Name" = "Examples";
            "SystemGroup" = 0;
            "Type" = "ACTION_DATA_GROUP";
          };
          "Data_2Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_1" = {
            "Comment" = "After pressing Ctrl+Alt+I, the KSIRC window will be activated, if it exists. Simple.";
            "Enabled" = false;
            "Name" = "Activate KSIRC Window";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_1Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_1Actions0" = {
            "Type" = "ACTIVATE_WINDOW";
          };
          "Data_2_1Actions0Window" = {
            "Comment" = "KSIRC window";
            "WindowsCount" = 1;
          };
          "Data_2_1Actions0Window0" = {
            "Class" = "ksirc";
            "ClassType" = 1;
            "Comment" = "KSIRC";
            "Role" = "";
            "RoleType" = 0;
            "Title" = "";
            "TitleType" = 0;
            "Type" = "SIMPLE";
            "WindowTypes" = 33;
          };
          "Data_2_1Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_1Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_2_1Triggers0" = {
            "Key" = "Ctrl+Alt+I";
            "Type" = "SHORTCUT";
          };
          "Data_2_2" = {
            "Comment" =
              "After pressing Alt+Ctrl+H the input of 'Hello' will be simulated, as if you typed it.  This is especially useful if you have call to frequently type a word (for instance, 'unsigned').  Every keypress in the input is separated by a colon ':'. Note that the keypresses literally mean keypresses, so you have to write what you would press on the keyboard. In the table below, the left column shows the input and the right column shows what to type.\n\n\"enter\" (i.e. new line)                Enter or Return\na (i.e. small a)                          A\nA (i.e. capital a)                       Shift+A\n: (colon)                                  Shift+;\n' '  (space)                              Space";
            "Enabled" = false;
            "Name" = "Type 'Hello'";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_2Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_2Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Shift+H:E:L:L:O\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_2Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_2Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_2_2Triggers0" = {
            "Key" = "Ctrl+Alt+H";
            "Type" = "SHORTCUT";
          };
          "Data_2_3" = {
            "Comment" = "This action runs Konsole, after pressing Ctrl+Alt+T.";
            "Enabled" = false;
            "Name" = "Run Konsole";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_3Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_3Actions0" = {
            "CommandURL" = "konsole";
            "Type" = "COMMAND_URL";
          };
          "Data_2_3Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_3Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_2_3Triggers0" = {
            "Key" = "Ctrl+Alt+T";
            "Type" = "SHORTCUT";
          };
          "Data_2_4" = {
            "Comment" =
              "Read the comment on the \"Type 'Hello'\" action first.\n\nQt Designer uses Ctrl+F4 for closing windows.  In KDE, however, Ctrl+F4 is the shortcut for going to virtual desktop 4, so this shortcut does not work in Qt Designer.  Further, Qt Designer does not use KDE's standard Ctrl+W for closing the window.\n\nThis problem can be solved by remapping Ctrl+W to Ctrl+F4 when the active window is Qt Designer. When Qt Designer is active, every time Ctrl+W is pressed, Ctrl+F4 will be sent to Qt Designer instead. In other applications, the effect of Ctrl+W is unchanged.\n\nWe now need to specify three things: A new shortcut trigger on 'Ctrl+W', a new keyboard input action sending Ctrl+F4, and a new condition that the active window is Qt Designer.\nQt Designer seems to always have title 'Qt Designer by Trolltech', so the condition will check for the active window having that title.";
            "Enabled" = false;
            "Name" = "Remap Ctrl+W to Ctrl+F4 in Qt Designer";
            "Type" = "GENERIC_ACTION_DATA";
          };
          "Data_2_4Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_4Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+F4";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_4Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 1;
          };
          "Data_2_4Conditions0" = {
            "Type" = "ACTIVE_WINDOW";
          };
          "Data_2_4Conditions0Window" = {
            "Comment" = "Qt Designer";
            "WindowsCount" = 1;
          };
          "Data_2_4Conditions0Window0" = {
            "Class" = "";
            "ClassType" = 0;
            "Comment" = "";
            "Role" = "";
            "RoleType" = 0;
            "Title" = "Qt Designer by Trolltech";
            "TitleType" = 2;
            "Type" = "SIMPLE";
            "WindowTypes" = 33;
          };
          "Data_2_4Triggers" = {
            "Comment" = "";
            "TriggersCount" = 1;
          };
          "Data_2_4Triggers0" = {
            "Key" = "Ctrl+W";
            "Type" = "SHORTCUT";
          };
          "Data_2_5" = {
            "Comment" =
              "By pressing Alt+Ctrl+W a D-Bus call will be performed that will show the minicli. You can use any kind of D-Bus call, just like using the command line 'qdbus' tool.";
            "Enabled" = false;
            "Name" = "Perform D-Bus call 'qdbus org.kde.krunner /App display'";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_5Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_5Actions0" = {
            "Arguments" = "";
            "Call" = "popupExecuteCommand";
            "RemoteApp" = "org.kde.krunner";
            "RemoteObj" = "/App";
            "Type" = "DBUS";
          };
          "Data_2_5Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_5Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_2_5Triggers0" = {
            "Key" = "Ctrl+Alt+W";
            "Type" = "SHORTCUT";
          };
          "Data_2_6" = {
            "Comment" =
              "Read the comment on the \"Type 'Hello'\" action first.\n\nJust like the \"Type 'Hello'\" action, this one simulates keyboard input, specifically, after pressing Ctrl+Alt+B, it sends B to XMMS (B in XMMS jumps to the next song). The 'Send to specific window' checkbox is checked and a window with its class containing 'XMMS_Player' is specified; this will make the input always be sent to this window. This way, you can control XMMS even if, for instance, it is on a different virtual desktop.\n\n(Run 'xprop' and click on the XMMS window and search for WM_CLASS to see 'XMMS_Player').";
            "Enabled" = false;
            "Name" = "Next in XMMS";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_6Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_6Actions0" = {
            "DestinationWindow" = 1;
            "Input" = "B";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_6Actions0DestinationWindow" = {
            "Comment" = "XMMS window";
            "WindowsCount" = 1;
          };
          "Data_2_6Actions0DestinationWindow0" = {
            "Class" = "XMMS_Player";
            "ClassType" = 1;
            "Comment" = "XMMS Player window";
            "Role" = "";
            "RoleType" = 0;
            "Title" = "";
            "TitleType" = 0;
            "Type" = "SIMPLE";
            "WindowTypes" = 33;
          };
          "Data_2_6Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_6Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_2_6Triggers0" = {
            "Key" = "Ctrl+Alt+B";
            "Type" = "SHORTCUT";
          };
          "Data_2_7" = {
            "Comment" =
              "Konqueror in KDE3.1 has tabs, and now you can also have gestures.\n\nJust press the middle mouse button and start drawing one of the gestures, and after you are finished, release the mouse button. If you only need to paste the selection, it still works, just click the middle mouse button. (You can change the mouse button to use in the global settings).\n\nRight now, there are the following gestures available:\nmove right and back left - Forward (Alt+Right)\nmove left and back right - Back (Alt+Left)\nmove up and back down  - Up (Alt+Up)\ncircle counterclockwise - Reload (F5)\n\nThe gesture shapes can be entered by performing them in the configuration dialog. You can also look at your numeric pad to help you: gestures are recognized like a 3x3 grid of fields, numbered 1 to 9.\n\nNote that you must perform exactly the gesture to trigger the action. Because of this, it is possible to enter more gestures for the action. You should try to avoid complicated gestures where you change the direction of mouse movement more than once.  For instance, 45654 or 74123 are simple to perform, but 1236987 may be already quite difficult.\n\nThe conditions for all gestures are defined in this group. All these gestures are active only if the active window is Konqueror (class contains 'konqueror').";
            "DataCount" = 4;
            "Enabled" = false;
            "Name" = "Konqi Gestures";
            "SystemGroup" = 0;
            "Type" = "ACTION_DATA_GROUP";
          };
          "Data_2_7Conditions" = {
            "Comment" = "Konqueror window";
            "ConditionsCount" = 1;
          };
          "Data_2_7Conditions0" = {
            "Type" = "ACTIVE_WINDOW";
          };
          "Data_2_7Conditions0Window" = {
            "Comment" = "Konqueror";
            "WindowsCount" = 1;
          };
          "Data_2_7Conditions0Window0" = {
            "Class" = "konqueror";
            "ClassType" = 1;
            "Comment" = "Konqueror";
            "Role" = "";
            "RoleType" = 0;
            "Title" = "";
            "TitleType" = 0;
            "Type" = "SIMPLE";
            "WindowTypes" = 33;
          };
          "Data_2_7_1" = {
            "Comment" = "";
            "Enabled" = false;
            "Name" = "Back";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_7_1Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_7_1Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Left";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_7_1Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_7_1Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 3;
          };
          "Data_2_7_1Triggers0" = {
            "GesturePointData" =
              "0,0.0625,1,1,0.5,0.0625,0.0625,1,0.875,0.5,0.125,0.0625,1,0.75,0.5,0.1875,0.0625,1,0.625,0.5,0.25,0.0625,1,0.5,0.5,0.3125,0.0625,1,0.375,0.5,0.375,0.0625,1,0.25,0.5,0.4375,0.0625,1,0.125,0.5,0.5,0.0625,0,0,0.5,0.5625,0.0625,0,0.125,0.5,0.625,0.0625,0,0.25,0.5,0.6875,0.0625,0,0.375,0.5,0.75,0.0625,0,0.5,0.5,0.8125,0.0625,0,0.625,0.5,0.875,0.0625,0,0.75,0.5,0.9375,0.0625,0,0.875,0.5,1,0,0,1,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_1Triggers1" = {
            "GesturePointData" =
              "0,0.0833333,1,0.5,0.5,0.0833333,0.0833333,1,0.375,0.5,0.166667,0.0833333,1,0.25,0.5,0.25,0.0833333,1,0.125,0.5,0.333333,0.0833333,0,0,0.5,0.416667,0.0833333,0,0.125,0.5,0.5,0.0833333,0,0.25,0.5,0.583333,0.0833333,0,0.375,0.5,0.666667,0.0833333,0,0.5,0.5,0.75,0.0833333,0,0.625,0.5,0.833333,0.0833333,0,0.75,0.5,0.916667,0.0833333,0,0.875,0.5,1,0,0,1,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_1Triggers2" = {
            "GesturePointData" =
              "0,0.0833333,1,1,0.5,0.0833333,0.0833333,1,0.875,0.5,0.166667,0.0833333,1,0.75,0.5,0.25,0.0833333,1,0.625,0.5,0.333333,0.0833333,1,0.5,0.5,0.416667,0.0833333,1,0.375,0.5,0.5,0.0833333,1,0.25,0.5,0.583333,0.0833333,1,0.125,0.5,0.666667,0.0833333,0,0,0.5,0.75,0.0833333,0,0.125,0.5,0.833333,0.0833333,0,0.25,0.5,0.916667,0.0833333,0,0.375,0.5,1,0,0,0.5,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_2" = {
            "Comment" = "";
            "Enabled" = false;
            "Name" = "Forward";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_7_2Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_7_2Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Right";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_7_2Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_7_2Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 3;
          };
          "Data_2_7_2Triggers0" = {
            "GesturePointData" =
              "0,0.0625,0,0,0.5,0.0625,0.0625,0,0.125,0.5,0.125,0.0625,0,0.25,0.5,0.1875,0.0625,0,0.375,0.5,0.25,0.0625,0,0.5,0.5,0.3125,0.0625,0,0.625,0.5,0.375,0.0625,0,0.75,0.5,0.4375,0.0625,0,0.875,0.5,0.5,0.0625,1,1,0.5,0.5625,0.0625,1,0.875,0.5,0.625,0.0625,1,0.75,0.5,0.6875,0.0625,1,0.625,0.5,0.75,0.0625,1,0.5,0.5,0.8125,0.0625,1,0.375,0.5,0.875,0.0625,1,0.25,0.5,0.9375,0.0625,1,0.125,0.5,1,0,0,0,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_2Triggers1" = {
            "GesturePointData" =
              "0,0.0833333,0,0.5,0.5,0.0833333,0.0833333,0,0.625,0.5,0.166667,0.0833333,0,0.75,0.5,0.25,0.0833333,0,0.875,0.5,0.333333,0.0833333,1,1,0.5,0.416667,0.0833333,1,0.875,0.5,0.5,0.0833333,1,0.75,0.5,0.583333,0.0833333,1,0.625,0.5,0.666667,0.0833333,1,0.5,0.5,0.75,0.0833333,1,0.375,0.5,0.833333,0.0833333,1,0.25,0.5,0.916667,0.0833333,1,0.125,0.5,1,0,0,0,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_2Triggers2" = {
            "GesturePointData" =
              "0,0.0833333,0,0,0.5,0.0833333,0.0833333,0,0.125,0.5,0.166667,0.0833333,0,0.25,0.5,0.25,0.0833333,0,0.375,0.5,0.333333,0.0833333,0,0.5,0.5,0.416667,0.0833333,0,0.625,0.5,0.5,0.0833333,0,0.75,0.5,0.583333,0.0833333,0,0.875,0.5,0.666667,0.0833333,1,1,0.5,0.75,0.0833333,1,0.875,0.5,0.833333,0.0833333,1,0.75,0.5,0.916667,0.0833333,1,0.625,0.5,1,0,0,0.5,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_3" = {
            "Comment" = "";
            "Enabled" = false;
            "Name" = "Up";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_7_3Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_7_3Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Up";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_7_3Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_7_3Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 3;
          };
          "Data_2_7_3Triggers0" = {
            "GesturePointData" =
              "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
            "Type" = "GESTURE";
          };
          "Data_2_7_3Triggers1" = {
            "GesturePointData" =
              "0,0.0833333,-0.5,0.5,1,0.0833333,0.0833333,-0.5,0.5,0.875,0.166667,0.0833333,-0.5,0.5,0.75,0.25,0.0833333,-0.5,0.5,0.625,0.333333,0.0833333,-0.5,0.5,0.5,0.416667,0.0833333,-0.5,0.5,0.375,0.5,0.0833333,-0.5,0.5,0.25,0.583333,0.0833333,-0.5,0.5,0.125,0.666667,0.0833333,0.5,0.5,0,0.75,0.0833333,0.5,0.5,0.125,0.833333,0.0833333,0.5,0.5,0.25,0.916667,0.0833333,0.5,0.5,0.375,1,0,0,0.5,0.5";
            "Type" = "GESTURE";
          };
          "Data_2_7_3Triggers2" = {
            "GesturePointData" =
              "0,0.0833333,-0.5,0.5,0.5,0.0833333,0.0833333,-0.5,0.5,0.375,0.166667,0.0833333,-0.5,0.5,0.25,0.25,0.0833333,-0.5,0.5,0.125,0.333333,0.0833333,0.5,0.5,0,0.416667,0.0833333,0.5,0.5,0.125,0.5,0.0833333,0.5,0.5,0.25,0.583333,0.0833333,0.5,0.5,0.375,0.666667,0.0833333,0.5,0.5,0.5,0.75,0.0833333,0.5,0.5,0.625,0.833333,0.0833333,0.5,0.5,0.75,0.916667,0.0833333,0.5,0.5,0.875,1,0,0,0.5,1";
            "Type" = "GESTURE";
          };
          "Data_2_7_4" = {
            "Comment" = "";
            "Enabled" = false;
            "Name" = "Reload";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_7_4Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_7_4Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "F5";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_2_7_4Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_7_4Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 3;
          };
          "Data_2_7_4Triggers0" = {
            "GesturePointData" =
              "0,0.03125,0,0,1,0.03125,0.03125,0,0.125,1,0.0625,0.03125,0,0.25,1,0.09375,0.03125,0,0.375,1,0.125,0.03125,0,0.5,1,0.15625,0.03125,0,0.625,1,0.1875,0.03125,0,0.75,1,0.21875,0.03125,0,0.875,1,0.25,0.03125,-0.5,1,1,0.28125,0.03125,-0.5,1,0.875,0.3125,0.03125,-0.5,1,0.75,0.34375,0.03125,-0.5,1,0.625,0.375,0.03125,-0.5,1,0.5,0.40625,0.03125,-0.5,1,0.375,0.4375,0.03125,-0.5,1,0.25,0.46875,0.03125,-0.5,1,0.125,0.5,0.03125,1,1,0,0.53125,0.03125,1,0.875,0,0.5625,0.03125,1,0.75,0,0.59375,0.03125,1,0.625,0,0.625,0.03125,1,0.5,0,0.65625,0.03125,1,0.375,0,0.6875,0.03125,1,0.25,0,0.71875,0.03125,1,0.125,0,0.75,0.03125,0.5,0,0,0.78125,0.03125,0.5,0,0.125,0.8125,0.03125,0.5,0,0.25,0.84375,0.03125,0.5,0,0.375,0.875,0.03125,0.5,0,0.5,0.90625,0.03125,0.5,0,0.625,0.9375,0.03125,0.5,0,0.75,0.96875,0.03125,0.5,0,0.875,1,0,0,0,1";
            "Type" = "GESTURE";
          };
          "Data_2_7_4Triggers1" = {
            "GesturePointData" =
              "0,0.0277778,0,0,1,0.0277778,0.0277778,0,0.125,1,0.0555556,0.0277778,0,0.25,1,0.0833333,0.0277778,0,0.375,1,0.111111,0.0277778,0,0.5,1,0.138889,0.0277778,0,0.625,1,0.166667,0.0277778,0,0.75,1,0.194444,0.0277778,0,0.875,1,0.222222,0.0277778,-0.5,1,1,0.25,0.0277778,-0.5,1,0.875,0.277778,0.0277778,-0.5,1,0.75,0.305556,0.0277778,-0.5,1,0.625,0.333333,0.0277778,-0.5,1,0.5,0.361111,0.0277778,-0.5,1,0.375,0.388889,0.0277778,-0.5,1,0.25,0.416667,0.0277778,-0.5,1,0.125,0.444444,0.0277778,1,1,0,0.472222,0.0277778,1,0.875,0,0.5,0.0277778,1,0.75,0,0.527778,0.0277778,1,0.625,0,0.555556,0.0277778,1,0.5,0,0.583333,0.0277778,1,0.375,0,0.611111,0.0277778,1,0.25,0,0.638889,0.0277778,1,0.125,0,0.666667,0.0277778,0.5,0,0,0.694444,0.0277778,0.5,0,0.125,0.722222,0.0277778,0.5,0,0.25,0.75,0.0277778,0.5,0,0.375,0.777778,0.0277778,0.5,0,0.5,0.805556,0.0277778,0.5,0,0.625,0.833333,0.0277778,0.5,0,0.75,0.861111,0.0277778,0.5,0,0.875,0.888889,0.0277778,0,0,1,0.916667,0.0277778,0,0.125,1,0.944444,0.0277778,0,0.25,1,0.972222,0.0277778,0,0.375,1,1,0,0,0.5,1";
            "Type" = "GESTURE";
          };
          "Data_2_7_4Triggers2" = {
            "GesturePointData" =
              "0,0.0277778,0.5,0,0.5,0.0277778,0.0277778,0.5,0,0.625,0.0555556,0.0277778,0.5,0,0.75,0.0833333,0.0277778,0.5,0,0.875,0.111111,0.0277778,0,0,1,0.138889,0.0277778,0,0.125,1,0.166667,0.0277778,0,0.25,1,0.194444,0.0277778,0,0.375,1,0.222222,0.0277778,0,0.5,1,0.25,0.0277778,0,0.625,1,0.277778,0.0277778,0,0.75,1,0.305556,0.0277778,0,0.875,1,0.333333,0.0277778,-0.5,1,1,0.361111,0.0277778,-0.5,1,0.875,0.388889,0.0277778,-0.5,1,0.75,0.416667,0.0277778,-0.5,1,0.625,0.444444,0.0277778,-0.5,1,0.5,0.472222,0.0277778,-0.5,1,0.375,0.5,0.0277778,-0.5,1,0.25,0.527778,0.0277778,-0.5,1,0.125,0.555556,0.0277778,1,1,0,0.583333,0.0277778,1,0.875,0,0.611111,0.0277778,1,0.75,0,0.638889,0.0277778,1,0.625,0,0.666667,0.0277778,1,0.5,0,0.694444,0.0277778,1,0.375,0,0.722222,0.0277778,1,0.25,0,0.75,0.0277778,1,0.125,0,0.777778,0.0277778,0.5,0,0,0.805556,0.0277778,0.5,0,0.125,0.833333,0.0277778,0.5,0,0.25,0.861111,0.0277778,0.5,0,0.375,0.888889,0.0277778,0.5,0,0.5,0.916667,0.0277778,0.5,0,0.625,0.944444,0.0277778,0.5,0,0.75,0.972222,0.0277778,0.5,0,0.875,1,0,0,0,1";
            "Type" = "GESTURE";
          };
          "Data_2_8" = {
            "Comment" =
              "After pressing Win+E (Tux+E) a WWW browser will be launched, and it will open http://www.kde.org . You may run all kind of commands you can run in minicli (Alt+F2).";
            "Enabled" = false;
            "Name" = "Go to KDE Website";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_2_8Actions" = {
            "ActionsCount" = 1;
          };
          "Data_2_8Actions0" = {
            "CommandURL" = "http://www.kde.org";
            "Type" = "COMMAND_URL";
          };
          "Data_2_8Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_2_8Triggers" = {
            "Comment" = "Simple_action";
            "TriggersCount" = 1;
          };
          "Data_2_8Triggers0" = {
            "Key" = "Meta+E";
            "Type" = "SHORTCUT";
          };
          "Data_3" = {
            "Comment" = "Basic Konqueror gestures.";
            "DataCount" = 14;
            "Enabled" = true;
            "ImportId" = "konqueror_gestures_kde321";
            "Name" = "Konqueror Gestures";
            "SystemGroup" = 0;
            "Type" = "ACTION_DATA_GROUP";
          };
          "Data_3Conditions" = {
            "Comment" = "Konqueror window";
            "ConditionsCount" = 1;
          };
          "Data_3Conditions0" = {
            "Type" = "ACTIVE_WINDOW";
          };
          "Data_3Conditions0Window" = {
            "Comment" = "Konqueror";
            "WindowsCount" = 1;
          };
          "Data_3Conditions0Window0" = {
            "Class" = "^konquerors";
            "ClassType" = 3;
            "Comment" = "Konqueror";
            "Role" = "konqueror-mainwindow#1";
            "RoleType" = 0;
            "Title" = "file:/ - Konqueror";
            "TitleType" = 0;
            "Type" = "SIMPLE";
            "WindowTypes" = 1;
          };
          "Data_3_1" = {
            "Comment" = "Press, move left, release.";
            "Enabled" = true;
            "Name" = "Back";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_1Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_1Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Left";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_1Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_1Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_1Triggers0" = {
            "GesturePointData" =
              "0,0.125,1,1,0.5,0.125,0.125,1,0.875,0.5,0.25,0.125,1,0.75,0.5,0.375,0.125,1,0.625,0.5,0.5,0.125,1,0.5,0.5,0.625,0.125,1,0.375,0.5,0.75,0.125,1,0.25,0.5,0.875,0.125,1,0.125,0.5,1,0,0,0,0.5";
            "Type" = "GESTURE";
          };
          "Data_3_2" = {
            "Comment" = "Press, move down, move up, move down, release.";
            "Enabled" = true;
            "Name" = "Duplicate Tab";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_2Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_2Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+Shift+D\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_2Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_2Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_2Triggers0" = {
            "GesturePointData" =
              "0,0.0416667,0.5,0.5,0,0.0416667,0.0416667,0.5,0.5,0.125,0.0833333,0.0416667,0.5,0.5,0.25,0.125,0.0416667,0.5,0.5,0.375,0.166667,0.0416667,0.5,0.5,0.5,0.208333,0.0416667,0.5,0.5,0.625,0.25,0.0416667,0.5,0.5,0.75,0.291667,0.0416667,0.5,0.5,0.875,0.333333,0.0416667,-0.5,0.5,1,0.375,0.0416667,-0.5,0.5,0.875,0.416667,0.0416667,-0.5,0.5,0.75,0.458333,0.0416667,-0.5,0.5,0.625,0.5,0.0416667,-0.5,0.5,0.5,0.541667,0.0416667,-0.5,0.5,0.375,0.583333,0.0416667,-0.5,0.5,0.25,0.625,0.0416667,-0.5,0.5,0.125,0.666667,0.0416667,0.5,0.5,0,0.708333,0.0416667,0.5,0.5,0.125,0.75,0.0416667,0.5,0.5,0.25,0.791667,0.0416667,0.5,0.5,0.375,0.833333,0.0416667,0.5,0.5,0.5,0.875,0.0416667,0.5,0.5,0.625,0.916667,0.0416667,0.5,0.5,0.75,0.958333,0.0416667,0.5,0.5,0.875,1,0,0,0.5,1";
            "Type" = "GESTURE";
          };
          "Data_3_3" = {
            "Comment" = "Press, move down, move up, release.";
            "Enabled" = true;
            "Name" = "Duplicate Window";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_3Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_3Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+D\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_3Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_3Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_3Triggers0" = {
            "GesturePointData" =
              "0,0.0625,0.5,0.5,0,0.0625,0.0625,0.5,0.5,0.125,0.125,0.0625,0.5,0.5,0.25,0.1875,0.0625,0.5,0.5,0.375,0.25,0.0625,0.5,0.5,0.5,0.3125,0.0625,0.5,0.5,0.625,0.375,0.0625,0.5,0.5,0.75,0.4375,0.0625,0.5,0.5,0.875,0.5,0.0625,-0.5,0.5,1,0.5625,0.0625,-0.5,0.5,0.875,0.625,0.0625,-0.5,0.5,0.75,0.6875,0.0625,-0.5,0.5,0.625,0.75,0.0625,-0.5,0.5,0.5,0.8125,0.0625,-0.5,0.5,0.375,0.875,0.0625,-0.5,0.5,0.25,0.9375,0.0625,-0.5,0.5,0.125,1,0,0,0.5,0";
            "Type" = "GESTURE";
          };
          "Data_3_4" = {
            "Comment" = "Press, move right, release.";
            "Enabled" = true;
            "Name" = "Forward";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_4Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_4Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Right";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_4Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_4Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_4Triggers0" = {
            "GesturePointData" =
              "0,0.125,0,0,0.5,0.125,0.125,0,0.125,0.5,0.25,0.125,0,0.25,0.5,0.375,0.125,0,0.375,0.5,0.5,0.125,0,0.5,0.5,0.625,0.125,0,0.625,0.5,0.75,0.125,0,0.75,0.5,0.875,0.125,0,0.875,0.5,1,0,0,1,0.5";
            "Type" = "GESTURE";
          };
          "Data_3_5" = {
            "Comment" =
              "Press, move down, move half up, move right, move down, release.\n(Drawing a lowercase 'h'.)";
            "Enabled" = true;
            "Name" = "Home";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_5Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_5Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Home\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_5Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_5Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 2;
          };
          "Data_3_5Triggers0" = {
            "GesturePointData" =
              "0,0.0461748,0.5,0,0,0.0461748,0.0461748,0.5,0,0.125,0.0923495,0.0461748,0.5,0,0.25,0.138524,0.0461748,0.5,0,0.375,0.184699,0.0461748,0.5,0,0.5,0.230874,0.0461748,0.5,0,0.625,0.277049,0.0461748,0.5,0,0.75,0.323223,0.0461748,0.5,0,0.875,0.369398,0.065301,-0.25,0,1,0.434699,0.065301,-0.25,0.125,0.875,0.5,0.065301,-0.25,0.25,0.75,0.565301,0.065301,-0.25,0.375,0.625,0.630602,0.0461748,0,0.5,0.5,0.676777,0.0461748,0,0.625,0.5,0.722951,0.0461748,0,0.75,0.5,0.769126,0.0461748,0,0.875,0.5,0.815301,0.0461748,0.5,1,0.5,0.861476,0.0461748,0.5,1,0.625,0.90765,0.0461748,0.5,1,0.75,0.953825,0.0461748,0.5,1,0.875,1,0,0,1,1";
            "Type" = "GESTURE";
          };
          "Data_3_5Triggers1" = {
            "GesturePointData" =
              "0,0.0416667,0.5,0,0,0.0416667,0.0416667,0.5,0,0.125,0.0833333,0.0416667,0.5,0,0.25,0.125,0.0416667,0.5,0,0.375,0.166667,0.0416667,0.5,0,0.5,0.208333,0.0416667,0.5,0,0.625,0.25,0.0416667,0.5,0,0.75,0.291667,0.0416667,0.5,0,0.875,0.333333,0.0416667,-0.5,0,1,0.375,0.0416667,-0.5,0,0.875,0.416667,0.0416667,-0.5,0,0.75,0.458333,0.0416667,-0.5,0,0.625,0.5,0.0416667,0,0,0.5,0.541667,0.0416667,0,0.125,0.5,0.583333,0.0416667,0,0.25,0.5,0.625,0.0416667,0,0.375,0.5,0.666667,0.0416667,0,0.5,0.5,0.708333,0.0416667,0,0.625,0.5,0.75,0.0416667,0,0.75,0.5,0.791667,0.0416667,0,0.875,0.5,0.833333,0.0416667,0.5,1,0.5,0.875,0.0416667,0.5,1,0.625,0.916667,0.0416667,0.5,1,0.75,0.958333,0.0416667,0.5,1,0.875,1,0,0,1,1";
            "Type" = "GESTURE";
          };
          "Data_3_6" = {
            "Comment" =
              "Press, move right, move down, move right, release.\nMozilla-style: Press, move down, move right, release.";
            "Enabled" = true;
            "Name" = "Close Tab";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_6Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_6Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+W\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_6Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_6Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 2;
          };
          "Data_3_6Triggers0" = {
            "GesturePointData" =
              "0,0.0625,0,0,0,0.0625,0.0625,0,0.125,0,0.125,0.0625,0,0.25,0,0.1875,0.0625,0,0.375,0,0.25,0.0625,0.5,0.5,0,0.3125,0.0625,0.5,0.5,0.125,0.375,0.0625,0.5,0.5,0.25,0.4375,0.0625,0.5,0.5,0.375,0.5,0.0625,0.5,0.5,0.5,0.5625,0.0625,0.5,0.5,0.625,0.625,0.0625,0.5,0.5,0.75,0.6875,0.0625,0.5,0.5,0.875,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
            "Type" = "GESTURE";
          };
          "Data_3_6Triggers1" = {
            "GesturePointData" =
              "0,0.0625,0.5,0,0,0.0625,0.0625,0.5,0,0.125,0.125,0.0625,0.5,0,0.25,0.1875,0.0625,0.5,0,0.375,0.25,0.0625,0.5,0,0.5,0.3125,0.0625,0.5,0,0.625,0.375,0.0625,0.5,0,0.75,0.4375,0.0625,0.5,0,0.875,0.5,0.0625,0,0,1,0.5625,0.0625,0,0.125,1,0.625,0.0625,0,0.25,1,0.6875,0.0625,0,0.375,1,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
            "Type" = "GESTURE";
          };
          "Data_3_7" = {
            "Comment" =
              "Press, move up, release.\nConflicts with Opera-style 'Up #2', which is disabled by default.";
            "Enabled" = true;
            "Name" = "New Tab";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_7Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_7Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+Shift+N";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_7Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_7Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_7Triggers0" = {
            "GesturePointData" =
              "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
            "Type" = "GESTURE";
          };
          "Data_3_8" = {
            "Comment" = "Press, move down, release.";
            "Enabled" = true;
            "Name" = "New Window";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_8Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_8Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+N\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_8Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_8Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_8Triggers0" = {
            "GesturePointData" =
              "0,0.125,0.5,0.5,0,0.125,0.125,0.5,0.5,0.125,0.25,0.125,0.5,0.5,0.25,0.375,0.125,0.5,0.5,0.375,0.5,0.125,0.5,0.5,0.5,0.625,0.125,0.5,0.5,0.625,0.75,0.125,0.5,0.5,0.75,0.875,0.125,0.5,0.5,0.875,1,0,0,0.5,1";
            "Type" = "GESTURE";
          };
          "Data_3_9" = {
            "Comment" = "Press, move up, move down, release.";
            "Enabled" = true;
            "Name" = "Reload";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_9Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_9Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "F5";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_9Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_9Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_9Triggers0" = {
            "GesturePointData" =
              "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
            "Type" = "GESTURE";
          };
          "Data_3_10" = {
            "Comment" =
              "Opera-style: Press, move up, release.\nNOTE: Conflicts with 'New Tab', and as such is disabled by default.";
            "Enabled" = false;
            "Name" = "Stop Loading";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_10Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_10Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Escape\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_10Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_10Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_10Triggers0" = {
            "GesturePointData" =
              "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
            "Type" = "GESTURE";
          };
          "Data_3_11" = {
            "Comment" =
              "Going up in URL/directory structure.\nMozilla-style: Press, move up, move left, move up, release.";
            "Enabled" = true;
            "Name" = "Up";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_11Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_11Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Up";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_11Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_11Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_11Triggers0" = {
            "GesturePointData" =
              "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,1,1,0.5,0.3125,0.0625,1,0.875,0.5,0.375,0.0625,1,0.75,0.5,0.4375,0.0625,1,0.625,0.5,0.5,0.0625,1,0.5,0.5,0.5625,0.0625,1,0.375,0.5,0.625,0.0625,1,0.25,0.5,0.6875,0.0625,1,0.125,0.5,0.75,0.0625,-0.5,0,0.5,0.8125,0.0625,-0.5,0,0.375,0.875,0.0625,-0.5,0,0.25,0.9375,0.0625,-0.5,0,0.125,1,0,0,0,0";
            "Type" = "GESTURE";
          };
          "Data_3_12" = {
            "Comment" =
              "Going up in URL/directory structure.\nOpera-style: Press, move up, move left, move up, release.\nNOTE: Conflicts with  \"Activate Previous Tab\", and as such is disabled by default.";
            "Enabled" = false;
            "Name" = "Up #2";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_12Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_12Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Alt+Up\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_12Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_12Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_12Triggers0" = {
            "GesturePointData" =
              "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
            "Type" = "GESTURE";
          };
          "Data_3_13" = {
            "Comment" = "Press, move up, move right, release.";
            "Enabled" = true;
            "Name" = "Activate Next Tab";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_13Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_13Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+.\n";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_13Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_13Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_13Triggers0" = {
            "GesturePointData" =
              "0,0.0625,-0.5,0,1,0.0625,0.0625,-0.5,0,0.875,0.125,0.0625,-0.5,0,0.75,0.1875,0.0625,-0.5,0,0.625,0.25,0.0625,-0.5,0,0.5,0.3125,0.0625,-0.5,0,0.375,0.375,0.0625,-0.5,0,0.25,0.4375,0.0625,-0.5,0,0.125,0.5,0.0625,0,0,0,0.5625,0.0625,0,0.125,0,0.625,0.0625,0,0.25,0,0.6875,0.0625,0,0.375,0,0.75,0.0625,0,0.5,0,0.8125,0.0625,0,0.625,0,0.875,0.0625,0,0.75,0,0.9375,0.0625,0,0.875,0,1,0,0,1,0";
            "Type" = "GESTURE";
          };
          "Data_3_14" = {
            "Comment" = "Press, move up, move left, release.";
            "Enabled" = true;
            "Name" = "Activate Previous Tab";
            "Type" = "SIMPLE_ACTION_DATA";
          };
          "Data_3_14Actions" = {
            "ActionsCount" = 1;
          };
          "Data_3_14Actions0" = {
            "DestinationWindow" = 2;
            "Input" = "Ctrl+,";
            "Type" = "KEYBOARD_INPUT";
          };
          "Data_3_14Conditions" = {
            "Comment" = "";
            "ConditionsCount" = 0;
          };
          "Data_3_14Triggers" = {
            "Comment" = "Gesture_triggers";
            "TriggersCount" = 1;
          };
          "Data_3_14Triggers0" = {
            "GesturePointData" =
              "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
            "Type" = "GESTURE";
          };
          "Gestures" = {
            "Disabled" = true;
            "MouseButton" = 2;
            "Timeout" = 300;
          };
          "GesturesExclude" = {
            "Comment" = "";
            "WindowsCount" = 0;
          };
          "Main" = {
            "AlreadyImported" = "defaults,kde32b1,konqueror_gestures_kde321";
            "Disabled" = false;
          };
          "Voice" = {
            "Shortcut" = "";
          };
        };

        "kiorc" = {
          "Confirmations" = {
            "ConfirmDelete" = true;
            "ConfirmEmptyTrash" = true;
            "ConfirmTrash" = false;
          };
          "Executable scripts" = {
            "behaviourOnLaunch" = "alwaysAsk";
          };
        };

        "krunnerrc" = {
          "Plugins" = {
            "baloosearchEnabled" = true;
          };
          "General" = {
            "FreeFloating" = true;
            "historyBehavior" = "ImmediateCompletion";
          };
        };

        "kscreenlockerrc" = {
          "Greeter/Wallpaper/org.kde.image/General" = {
            "Image" =
              "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/54808358047_d75419ff26_o.jpg";
          };
        };

        "kservicemenurc" = {
          "Show" = {
            "compressfileitemaction" = true;
            "extractfileitemaction" = true;
            "forgetfileitemaction" = true;
            "installFont" = true;
            "kactivitymanagerd_fileitem_linking_plugin" = true;
            "kdeconnectfileitemaction" = true;
            "kio-admin" = true;
            "kompare" = true;
            "makefileactions" = true;
            "mountisoaction" = true;
            "runInKonsole" = true;
            "setAsWallpaper" = true;
            "slideshowfileitemaction" = true;
            "tagsfileitemaction" = true;
            "wallpaperfileitemaction" = true;
          };
        };

        "ksmserverrc" = {
          "General" = {
            "loginMode" = "emptySession";
          };
        };

        "ksplashrc" = {
          "KSplash" = {
            "Engine" = "none";
            "Theme" = "none";
          };
        };

        "kwalletrc" = {
          "Wallet" = {
            "First Use" = false;
          };
        };

        "kwinrc" = {
          "Effect-overview" = {
            "TouchBorderActivate" = 4;
          };
          "Effect-windowview" = {
            "BorderActivateAll" = 9;
          };
          "ElectricBorders" = {
            "BottomRight" = "ShowDesktop";
          };
          "NightColor" = {
            "Active" = true;
            "LatitudeAuto" = 50.83;
            "LongitudeAuto" = 8.1;
            "NightTemperature" = 3500;
          };
          "Plugins" = {
            "blurEnabled" = true;
            "dimscreenEnabled" = true;
            "kwin4_effect_dimscreenEnabled" = true;
            "kwin4_effect_translucencyEnabled" = true;
            "translucencyEnabled" = true;
          };
          "TabBox" = {
            "LayoutName" = "thumbnail_grid";
          };
          "TabBoxAlternative" = {
            "LayoutName" = "big_icons";
          };
          "Tiling" = {
            "padding" = 4;
          };
          "TouchEdges" = {
            "Left" = "ApplicationLauncher";
            "Right" = "LockScreen";
            "Top" = "KRunner";
          };
          "Wayland" = {
            "InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
            "InputMethodx5b$ex5" =
              "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
            "VirtualKeyboardEnabled" = true;
          };
          "Xwayland" = {
            "Scale" = 1;
          };
          "org.kde.kdecoration2" = {
            "ButtonsOnLeft" = "F";
          };
        };

        "kxkbrc" = {
          "Layout" = {
            "LayoutList" = "de";
            "Use" = true;
          };
        };

        "plasma_calendar_holiday_regions" = {
          "General" = {
            "selectedRegions" = "de_de";
          };
        };

        "plasma-localerc" = {
          "Formats" = {
            "LANG" = "en_US.UTF-8";
            "LC_ADDRESS" = "de_DE.UTF-8";
            "LC_MEASUREMENT" = "de_DE.UTF-8";
            "LC_MONETARY" = "de_DE.UTF-8";
            "LC_NAME" = "de_DE.UTF-8";
            "LC_NUMERIC" = "de_DE.UTF-8";
            "LC_PAPER" = "de_DE.UTF-8";
            "LC_TELEPHONE" = "de_DE.UTF-8";
            "LC_TIME" = "de_DE.UTF-8";
          };
        };

        "plasmanotifyrc" = {
          "Notifications" = {
            "LowPriorityHistory" = true;
          };
          "DoNotDisturb" = {
            "WhenScreensMirrored" = false;
          };
        };

        "systemsettingsrc" = {
          "KFileDialog Settings" = {
            "detailViewIconSize" = 64;
          };
          "MainWindow" = {
            "MenuBar" = "Disabled";
          };
        };

        "kactivitymanagerd-pluginsrc" = {
          "Plugin-org.kde.ActivityManager.Resources.Scoring" = {
            "keep-history-for" = 1;
          };
        };

        "ktrashrc" = {
          "/" = {
            "Days" = 7;
            "LimitReachedAction" = 0;
            "Percent" = 10;
            "UseSizeLimit" = true;
            "UseTimeLimit" = false;
          };
          "///" = {
            "Days" = 7;
            "Percent" = 10;
            "UseSizeLimit" = true;
            "UseTimeLimit" = true;
          };
          "/////" = {
            "Days" = 7;
            "Percent" = 10;
            "UseSizeLimit" = true;
            "UseTimeLimit" = true;
          };
          "/home/${userName}/.local/share/Trash" = {
            "Days" = 7;
            "LimitReachedAction" = 0;
            "Percent" = 10;
            "UseSizeLimit" = true;
            "UseTimeLimit" = false;
          };
        };
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".local/share/baloo"
        ".local/share/klipper"
        ".local/share/kwalletd"
        ".local/share/plasma_notes"
      ];
    };
  };
}

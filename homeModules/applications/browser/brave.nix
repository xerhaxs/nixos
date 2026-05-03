{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.browser.brave = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable brave browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.brave.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;

      commandLineArgs = [
        "--ozone-platform=wayland"
        "--ozone-platform-hint=auto"
        "--enable-features=WaylandWindowDecorations"
        "--no-first-run"
        "--no-default-browser-check"
        "--enable-features=AllowQt"
        "--force-webrtc-ip-handling-policy=disable_non_proxied_udp"
      ];

      nativeMessagingHosts = with pkgs; [
        kdePackages.plasma-browser-integration
        keepassxc
      ];
    };

    xdg.configFile."BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".text =
      builtins.toJSON {
        name = "org.keepassxc.keepassxc_browser";
        description = "KeePassXC integration with native messaging support";
        path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
        type = "stdio";
        allowed_origins = [
          "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
        ];
      };

    home.activation.braveConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PREFS="$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences"
      if [ -f "$PREFS" ]; then
        ${pkgs.jq}/bin/jq '
          .browser.custom_chrome_frame                  = false |
          .browser.show_home_button                     = false |
          .browser.show_forward_button                  = true  |
          .browser.clear_data.browsing_history_on_exit  = true  |
          .browser.clear_data.cache_on_exit             = true  |
          .browser.clear_data.cookies_on_exit           = true  |
          .browser.clear_data.download_history_on_exit  = true  |
          .browser.clear_data.passwords                 = true  |
          .browser.clear_data.site_settings             = true  |
          .browser.clear_data.form_data                 = true  |
          .browser.clear_data.hosted_apps_data          = true  |
          .browser.clear_data.brave_leo_on_exit         = true  |
          .browser.clear_data.time_period               = 4     |
          .bookmark_bar.show_on_all_tabs                = true  |
          .bookmark_bar.show_tab_groups                 = false |
          .brave.has_seen_brave_welcome_page            = true  |
          .brave.location_bar_is_wide                   = true  |
          .brave.enable_window_closing_confirm          = true  |
          .brave.show_bookmarks_button                  = true  |
          .brave.show_side_panel_button                 = false |
          .brave.pin_share_menu_button                  = false |
          .brave.fb_embed_default                       = false |
          .brave.twitter_embed_default                  = false |
          .brave.web_view_rounded_corners               = false |
          .brave.wallet.show_wallet_icon_on_toolbar     = false |
          .brave.tabs.hover_mode                        = 2     |
          .brave.tabs.vertical_tabs_enabled             = false |
          .omnibox.prevent_url_elisions                 = true  |
          .session.restore_on_startup                   = 5     |
          .side_panel.is_right_aligned                  = false |
          .signin.allowed                               = false |
          .translate_blocked_languages                  = ["en","de"] |
          .privacy_sandbox.first_party_sets_enabled     = false |
          .privacy_sandbox.m1.ad_measurement_enabled    = false |
          .privacy_sandbox.m1.fledge_enabled            = false |
          .privacy_sandbox.m1.topics_enabled            = false |

          .toolbar.pinned_actions = [
            "kActionNewIncognitoWindow",
            "kActionShowDownloads"
          ] |

          # pin: KeePassXC, SimpleLogin, floccus
          .extensions.pinned_extensions = [
            "oboonakemofpalcgghocfoadofidjkkk",
            "dphilobhebphkdjbpfohgikllaljmgbn",
            "fnaicdffflnofjppbagibeoednhnbjhg"
          ]
        ' "$PREFS" > "$PREFS.tmp" && mv "$PREFS.tmp" "$PREFS"
      fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/BraveSoftware"
      ];
    };
  };
}

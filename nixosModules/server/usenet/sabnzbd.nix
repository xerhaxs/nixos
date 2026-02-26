{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.usenet.sabnzbd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable SABnzbd.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.sabnzbd.enable {
    services.sabnzbd = {
      enable = true;
      user = "sabnzbd";
      group = "sabnzbd";
      openFirewall = false;
      allowConfigWrite = false;
      stateDir = "/var/lib/sabnzbd";
      #stateDir = "/pool01/applications/sabnzbd";
      #secretFiles = [
      #  config.sops.secrets."sabnzbd".path
      #];
      settings = {
        misc = {
          auto_browser = 0;
          bandwidth_max = "5M";
          bandwidth_perc = 0;
          cache_limit = "1G";
          check_new_rel = 0;
          complete_dir = "/pool01/shares/video/SABnzbd/done";
          config_conversion_version = 4;
          config_lock = 0;
          download_dir = "/pool01/shares/video/SABnzbd/temp";
          email_endjob = 0;
          email_from = "";
          #email_full = 0;
          #email_rss = 0;
          email_server = "";
          email_to = "";
          #enable_https = 0;
          host = "127.0.0.1";
          host_whitelist = "sabnzbd.${config.nixos.server.network.nginx.domain}";
          #html_login = 1;
          inet_exposure = 0;
          language = "en";
          notified_new_skin = 1;
          port = 8080;
          helpful_warnings = 1;
          queue_complete = "";
          queue_complete_pers = 0;
          refresh_rate = 0;
          interface_settings = "";
          queue_limit = 20;
          fixed_ports = 1;
          direct_unpack_tested = 0;
          sorters_converted = 0;
          enable_https_verification = 1;
          https_port = "";
          web_dir = "Glitter";
          web_color = "Auto";
          #https_cert = "server.cert";
          #https_key = "server.key";
          https_chain = "";
          socks5_proxy_url = "";
          permissions = "";
          download_free = "";
          complete_free = "1T";
          fulldisk_autoresume = 1;
          script_dir = "";
          nzb_backup_dir = "";
          admin_dir = "admin";
          backup_dir = "/pool01/shares/video/SABnzbd";
          dirscan_dir = "";
          dirscan_speed = 5;
          password_file = "";
          log_dir = "logs";
          max_art_tries = 3;
          top_only = 0;
          sfv_check = 1;
          script_can_fail = 0;
          enable_recursive = 1;
          flat_unpack = 0;
          par_option = "";
          pre_check = 1;
          nice = "";
          win_process_prio = 3;
          ionice = "";
          fail_hopeless_jobs = 1;
          fast_fail = 1;
          auto_disconnect = 1;
          pre_script = "None";
          end_queue_script = "None";
          no_dupes = 0;
          no_series_dupes = 0;
          no_smart_dupes = 0;
          dupes_propercheck = 1;
          pause_on_pwrar = 2;
          ignore_samples = 0;
          deobfuscate_final_filenames = 1;
          auto_sort = "";
          direct_unpack = 1;
          propagation_delay = 0;
          folder_rename = 1;
          replace_spaces = 1;
          replace_underscores = 0;
          replace_dots = 0;
          safe_postproc = 1;
          pause_on_post_processing = 0;
          enable_all_par = 0;
          sanitize_safe = 1;
          cleanup_list = "";
          unwanted_extensions = "";
          action_on_unwanted_extensions = 2;
          unwanted_extensions_mode = 0;
          new_nzb_on_failure = 0;
          history_retention = 0;
          history_retention_option = "all";
          history_retention_number = 1;
          quota_size = "";
          quota_day = "";
          quota_resume = 1;
          quota_period = "m";
          enable_tv_sorting = 0;
          tv_sort_string = "";
          tv_categories = "tv";
          enable_movie_sorting = 0;
          movie_sort_string = "";
          movie_sort_extra = "-cd%1";
          movie_categories = "movies";
          enable_date_sorting = 0;
          date_sort_string = "";
          date_categories = "tv";
          schedlines = "";
          rss_rate = 60;
          ampm = 0;
          start_paused = 0;
          preserve_paused_state = 0;
          enable_par_cleanup = 1;
          process_unpacked_par2 = 1;
          enable_unrar = 1;
          enable_7zip = 1;
          enable_filejoin = 1;
          enable_tsjoin = 1;
          overwrite_files = 0;
          ignore_unrar_dates = 0;
          backup_for_duplicates = 0;
          empty_postproc = 0;
          wait_for_dfolder = 0;
          rss_filenames = 0;
          api_logging = 1;
          disable_archive = 0;
          warn_dupl_jobs = 0;
          keep_awake = 1;
          tray_icon = 1;
          allow_incomplete_nzb = 0;
          enable_broadcast = 1;
          ipv6_hosting = 0;
          ipv6_staging = 0;
          api_warnings = 1;
          no_penalties = 0;
          x_frame_options = 1;
          allow_old_ssl_tls = 0;
          enable_season_sorting = 1;
          verify_xff_header = 0;
          rss_odd_titles = "nzbindex.nl/, nzbindex.com/, nzbclub.com/";
          quick_check_ext_ignore = "nfo, sfv, srr";
          req_completion_rate = "100.2";
          selftest_host = "self-test.sabnzbd.org";
          movie_rename_limit = "100M";
          episode_rename_limit = "20M";
          size_limit = 0;
          direct_unpack_threads = 3;
          history_limit = 10;
          wait_ext_drive = 5;
          max_foldername_length = 246;
          nomedia_marker = "";
          ipv6_servers = 1;
          url_base = "";
          local_ranges = "";
          max_url_retries = 10;
          downloader_sleep_time = 10;
          receive_threads = 2;
          switchinterval = "0.005";
          ssdp_broadcast_interval = 15;
          ext_rename_ignore = "";
          unrar_parameters = "";
          outgoing_nntp_ip = "";
          email_account = "";
          email_pwd = "";
          email_dir = "";
          email_cats = "*";
        };

        logging = {
          log_level = 1;
          max_log_size = 5242880;
          log_backups = 5;
        };

        servers = {
          "eunews.frugalusenet.com" = {
            name = "eunews.frugalusenet.com";
            displayname = "eunews.frugalusenet.com";
            host = "eunews.frugalusenet.com";
            port = 563;
            timeout = 60;
            connections = 8;
            ssl = true;
            ssl_verify = 3;
            enable = true;
            required = false;
            optional = false;
            retention = 0;
            priority = 1;
          };
          "news.frugalusenet.com" = {
            name = "news.frugalusenet.com";
            displayname = "news.frugalusenet.com";
            host = "news.frugalusenet.com";
            port = 563;
            timeout = 60;
            connections = 8;
            ssl = true;
            ssl_verify = 3;
            enable = true;
            priority = 2;
          };
          "bonus.frugalusenet.com" = {
            name = "bonus.frugalusenet.com";
            displayname = "bonus.frugalusenet.com";
            host = "bonus.frugalusenet.com";
            port = 563;
            timeout = 60;
            connections = 8;
            ssl = true;
            ssl_verify = 3;
            enable = true;
            priority = 5;
          };
          "news.newshosting.com" = {
            name = "news.newshosting.com";
            displayname = "news.newshosting.com";
            host = "news.newshosting.com";
            port = 563;
            timeout = 60;
            connections = 8;
            ssl = true;
            ssl_verify = 3;
            enable = true;
            priority = 1;
          };
          "eunews.blocknews.net" = {
            name = "eunews.blocknews.net";
            displayname = "eunews.blocknews.net";
            host = "eunews.blocknews.net";
            port = 563;
            timeout = 60;
            connections = 8;
            ssl = true;
            ssl_verify = 3;
            enable = true;
            priority = 7;
          };
          "eunews2.blocknews.net" = {
            name = "eunews2.blocknews.net";
            displayname = "eunews2.blocknews.net";
            host = "eunews2.blocknews.net";
            port = 563;
            timeout = 60;
            connections = 8;
            ssl = true;
            ssl_verify = 3;
            enable = true;
            priority = 9;
          };
        };

        categories = {
          "*" = {
            priority = 0;
          };
          movies = {
            priority = -100;
          };
          tv = {
            priority = -100;
          };
          audio = {
            priority = -100;
          };
          software = {
            priority = -100;
          };
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "sabnzbd.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8080";
          };
        };
      };
    };
  };
}

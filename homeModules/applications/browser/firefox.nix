{ config, lib, pkgs, ... }:



environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
  };

change to homesesionvariables

let

arkenfox-js = {
# Thanks to the arkenfox project! 
# https://github.com/arkenfox/user.js/blob/master/user.js

#  0100: STARTUP
#  0200: GEOLOCATION
#  0300: QUIETER FOX
#  0400: SAFE BROWSING
#  0600: BLOCK IMPLICIT OUTBOUND
#  0700: DNS / DoH / PROXY / SOCKS
#  0800: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
#  0900: PASSWORDS
#  1000: DISK AVOIDANCE
#  1200: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
#  1600: REFERERS
#  1700: CONTAINERS
#  2000: PLUGINS / MEDIA / WEBRTC
#  2400: DOM (DOCUMENT OBJECT MODEL)
#  2600: MISCELLANEOUS
#  2700: ETP (ENHANCED TRACKING PROTECTION)
#  2800: SHUTDOWN & SANITIZING
#  4000: FPP (fingerprintingProtection)
#  4500: RFP (resistFingerprinting)
#  5000: OPTIONAL OPSEC
#  5500: OPTIONAL HARDENING
#  6000: DON'T TOUCH
#  7000: DON'T BOTHER
#  8000: DON'T BOTHER: FINGERPRINTING
#  9000: MISC

# disable about:config warning
"browser.aboutConfig.showWarning" = false;

# disable about:config
#"general.aboutConfig.enable" = false;

### [SECTION 0100]: STARTUP
# set startup page [SETUP-CHROME]
# 0=blank, 1=home, 2=last visited page, 3=resume previous session
"browser.startup.page" = 1;

# set HOME+NEWWINDOW page
"browser.startup.homepage" = "about:newtab";

# set NEWTAB page
# true=Firefox Home, false=blank page
"browser.newtabpage.enabled" = true;

# disable sponsored content on Firefox Home (Activity Stream)
"browser.newtabpage.activity-stream.showSponsored" = false;
"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

# clear default topsites
"browser.newtabpage.activity-stream.default.sites" = "";

### [SECTION 0200]: GEOLOCATION
# use Mozilla geolocation service instead of Google if permission is granted [FF74+]
# enable logging to the console (defaults to false)
"geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
"geo.provider.network.logging.enabled" = true;

# disable using the OS's geolocation service
"geo.provider.ms-windows-location" = false; # [WINDOWS]
"geo.provider.use_corelocation" = false; # [MAC]
"geo.provider.use_gpsd" = false; # [LINUX] [HIDDEN PREF]]
"geo.provider.use_geoclue" = false; # [FF102+] [LINUX]

### [SECTION 0300]: QUIETER FOX
## RECOMMENDATIONS
# disable recommendation pane in about:addons (uses Google Analytics)
"extensions.getAddons.showPane" = false;

#disable recommendations in about:addons' Extensions and Themes panes [FF68+]
"extensions.htmlaboutaddons.recommendations.enabled" = false;

#disable personalized Extension Recommendations in about:addons and AMO [FF65+]
"browser.discovery.enabled" = false;

# disable shopping experience [FF116+]
"browser.shopping.experience2023.enabled" = false;

## TELEMETRY
# disable new data submission [FF41+]
"datareporting.policy.dataSubmissionEnabled" = false;

# disable Health Reports
"datareporting.healthreport.uploadEnabled" = false;

# disable telemetry
"toolkit.telemetry.unified" = false;
"toolkit.telemetry.enabled" = false;
"toolkit.telemetry.server" = "data";
"toolkit.telemetry.archive.enabled" = false;
"toolkit.telemetry.newProfilePing.enabled" = false;
"toolkit.telemetry.shutdownPingSender.enabled" = false;
"toolkit.telemetry.updatePing.enabled" = false;
"toolkit.telemetry.bhrPing.enabled" = false;
"toolkit.telemetry.firstShutdownPing.enabled" = false;

# disable Telemetry Coverage
"toolkit.telemetry.coverage.opt-out" = true;
"toolkit.coverage.opt-out" = true;
"toolkit.coverage.endpoint.base" = "";

# disable PingCentre telemetry (used in several System Add-ons) [FF57+]
"browser.ping-centre.telemetry" = false;

# disable Firefox Home (Activity Stream) telemetry
"browser.newtabpage.activity-stream.feeds.telemetry" = false;
"browser.newtabpage.activity-stream.telemetry" = false;

## STUDIES
# disable Studies
"app.shield.optoutstudies.enabled" = false;

# disable Normandy/Shield [FF60+]
"app.normandy.enabled" = false;
"app.normandy.api_url" = "";

## CRASH REPORTS
# disable Crash Reports
"breakpad.reportURL" = "";
"browser.tabs.crashReporting.sendReport" = false;
"browser.crashReports.unsubmittedCheck.enabled" = false;

# enforce no submission of backlogged Crash Reports [FF58+]
"browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

## FEEDBACK
# disable ask for feedback
"app.feedback.baseURL" = "";
"messaging-system.askForFeedback" = false;

## OTHER
# disable Captive Portal detection
"captivedetect.canonicalURL" = "http://detectportal.firefox.com/canonical.html";
#"captivedetect.canonicalURL" = "";
#"network.captive-portal-service.enabled" = false;

# disable Network Connectivity checks [FF65+]
#"network.connectivity-service.enabled" = false;

### SAFE BROWSING (SB)
# disable SB checks for downloads (remote)
"browser.safebrowsing.downloads.remote.enabled" = false;

### BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on]
# disable link prefetching
#"network.prefetch-next" = false;

# disable DNS prefetching
#"network.dns.disablePrefetch" = true;
"network.dns.disablePrefetchFromHTTPS" = true;

# disable predictor / prefetching
#"network.predictor.enabled" = false;
"network.predictor.enable-prefetch" = false;

# disable link-mouseover opening connection to linked server
"network.http.speculative-parallel-limit" = 0;

# disable mousedown speculative connections on bookmarks and history [FF98+]
"browser.places.speculativeConnect.enabled" = false;

# enforce no "Hyperlink Auditing" (click tracking)
"browser.send_pings" = false;

### [SECTION 0700]: DNS / DoH / PROXY / SOCKS
# set the proxy server to do any DNS lookups when using SOCKS
"network.proxy.socks_remote_dns" = true;

# disable using UNC (Uniform Naming Convention) paths [FF61+]
"network.file.disable_unc_paths" = true;

# disable GIO as a potential proxy bypass vector
"network.gio.supported-protocols" = "";

# enable DNS-over-HTTPS (DoH) [FF60+]
# 0=default, 2=increased (TRR (Trusted Recursive Resolver) first), 3=max (TRR only), 5=off (no rollout)
"network.trr.mode" = 2;

### [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
# disable location bar making speculative connections [FF56+]
"browser.urlbar.speculativeConnect.enabled" = false;

# disable location bar contextual suggestions
#"browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
"browser.urlbar.suggest.quicksuggest.sponsored" = false;

# disable live search suggestions
#"browser.search.suggest.enabled" = false;
#"browser.urlbar.suggest.searches" = false,

# disable urlbar trending search suggestions [FF118+]
"browser.urlbar.trending.featureGate" = false;

# disable urlbar suggestions
"browser.urlbar.addons.featureGate" = false;
"browser.urlbar.mdn.featureGate" = false;
"browser.urlbar.pocket.featureGate" = false;
"browser.urlbar.weather.featureGate" = false;

# disable search and form history
"browser.formfill.enable" = false;

# enable separate default search engine in Private Windows and its UI setting
"browser.search.separatePrivateDefault" = true;
"browser.search.separatePrivateDefault.ui.enabled" = true;

### [SECTION 0900]: PASSWORDS
# disable auto-filling username & password form fields
"signon.autofillForms" = false;

# disable formless login capture for Password Manager [FF51+]
"signon.formlessCapture.enabled" = false;

# limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources [FF41+]
# don't allow sub-resources to open HTTP authentication credentials dialogs
# 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
# 2 = allow sub-resources to open HTTP authentication credentials dialogs (default)
"network.auth.subresource-http-auth-allow" = 1;

# enforce no automatic authentication on Microsoft sites [FF91+] [WINDOWS 10+]
"network.http.windows-sso.enabled" = false;

### [SECTION 1000]: DISK AVOIDANCE
# disable disk cache
#"browser.cache.disk.enable" = false;

# disable media cache from writing to disk in Private Browsing
"browser.privatebrowsing.forceMediaMemoryCache" = true;
"media.memory_cache_max_size" = 65536;

# disable storing extra session data [SETUP-CHROME]
# define on which sites to save extra session data such as form content, cookies and POST data
# 0=everywhere, 1=unencrypted sites, 2=nowhere
"browser.sessionstore.privacy_level" = 2;

# disable automatic Firefox start and session restore after reboot [FF62+] [WINDOWS]
#"toolkit.winRegisterApplicationRestart" = false;

# disable favicons in shortcuts [WINDOWS]
"browser.shell.shortcutFavicons" = false;

### [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
## SSL (Secure Sockets Layer) / TLS (Transport Layer Security)
# require safe negotiation
"security.ssl.require_safe_negotiation" = true;

# disable TLS1.3 0-RTT (round-trip time) [FF51+]
"security.tls.enable_0rtt_data" = false;

## OCSP (Online Certificate Status Protocol)
# enforce OCSP fetching to confirm current validity of certificates
# 0=disabled, 1=enabled (default), 2=enabled for EV certificates only
"security.OCSP.enabled" = 1;

# set OCSP fetch failures (non-stapled, see 1211) to hard-fail
"security.OCSP.require" = true;

## CERTS / HPKP (HTTP Public Key Pinning)
# enable strict PKP (Public Key Pinning)
# 0=disabled, 1=allow user MiTM (default; such as your antivirus), 2=strict
"security.cert_pinning.enforcement_level" = 2;

# enable CRLite [FF73+]
# 0 = disabled
# 1 = consult CRLite but only collect telemetry
# 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
# 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" (default)
"security.remote_settings.crlite_filters.enabled" = true;
"security.pki.crlite_mode" = 2;

## MIXED CONTENT
# disable insecure passive content (such as images) on https pages
#"security.mixed_content.block_display_content" = true;

# enable HTTPS-Only mode in all windows
"dom.security.https_only_mode" = true;

# enable HTTPS-Only mode for local resources
"dom.security.https_only_mode.upgrade_local" = false;

# disable HTTP background requests
#"dom.security.https_only_mode_send_http_background_request" = false

## UI (User Interface)
# display warning on the padlock for "broken security"
"security.ssl.treat_unsafe_negotiation_as_broken" = true;

# display advanced information on Insecure Connection warning pages
"browser.xul.error_pages.expert_bad_cert" = true;

### [SECTION 1600]: REFERERS
# control the amount of cross-origin information to send [FF52+]
# 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port
"network.http.referer.XOriginTrimmingPolicy" = 2;

### [SECTION 1700]: CONTAINERS 
# enable Container Tabs and its UI setting [FF50+]
"privacy.userContext.enabled" = true;
"privacy.userContext.ui.enabled" = true;

# set behavior on "+ Tab" button to display container menu on left click [FF74+]
#"privacy.userContext.newTabContainerOnLeftClick.enabled" = true;

### [SECTION 2000]: PLUGINS / MEDIA / WEBRTC
# force WebRTC inside the proxy [FF70+]
"media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

# force a single network interface for ICE candidates generation [FF42+]
"media.peerconnection.ice.default_address_only" = true;

# force exclusion of private IPs from ICE candidates [FF51+]
#"media.peerconnection.ice.no_host" = true

# disable GMP (Gecko Media Plugins)
#"media.gmp-provider.enabled" = false;

### [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL)
# prevent scripts from moving and resizing open windows
"dom.disable_window_move_resize" = true;

### [SECTION 2600]: MISCELLANEOUS
# remove temp files opened from non-PB windows with an external application
"browser.download.start_downloads_in_tmp_dir" = true;
"browser.helperApps.deleteTempFileOnExit" = true;

# remove default search engines
"browser.policies.runOncePerModification.removeSearchEngines" = [ "Google" "Bing" "Amazon.com" "eBay" "Twitter" ];

# set default search engine
"browser.policies.runOncePerModification.setDefaultSearchEngine" = "DuckDuckGo";

# disable UITour backend so there is no chance that a remote page can use it
"browser.uitour.enabled" = false;
#"browser.uitour.url = "";

# reset remote debugging to disabled
"devtools.debugger.remote-enabled" = false;

# disable websites overriding Firefox's keyboard shortcuts [FF58+]
# 0 (default) or 1=allow, 2=block
"permissions.default.shortcuts" = 2;

# remove special permissions for certain mozilla domains [FF35+]
"permissions.manager.defaultsUrl" = "";

# remove webchannel whitelist
"webchannel.allowObject.urlWhitelist" = "";

# use Punycode in Internationalized Domain Names to eliminate possible spoofing
"network.IDN_show_punycode" = true;

# enforce PDFJS, disable PDFJS scripting
"pdfjs.disabled" = false;
"pdfjs.enableScripting" = false;

# enable middle click on new tab button opening URLs or searches using clipboard [FF115+]
"browser.tabs.searchclipboardfor.middleclick" = true;

# block multiple popups
"dom.block_multiple_popups" = true;

## DOWNLOADS
# enable user interaction for security by always asking where to download
"browser.download.useDownloadDir" = false;

# enable downloads panel opening on every download [FF96+]
"browser.download.alwaysOpenPanel" = true;

# enable adding downloads to the system's "recent documents" list
"browser.download.manager.addToRecentDocs" = true;

# enable user interaction for security by always asking how to handle new mimetypes [FF101+]
"browser.download.always_ask_before_handling_new_types" = true;

## EXTENSIONS
# limit allowed extension directories
# 1=profile, 2=user, 4=application, 8=system, 16=temporary, 31=all
#"extensions.enabledScopes" = 5;

# disable bypassing 3rd party extension install prompts [FF82+]
#"extensions.postDownloadThirdPartyPrompt" = false;

# disable webextension restrictions on certain mozilla domains
"extensions.webextensions.restrictedDomains" = "";

### [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION)
# enable ETP Strict Mode [FF86+]
"browser.contentblocking.category" = false;

# disable ETP web compat features [FF93+]
#"privacy.antitracking.enableWebcompat" = false;

### [SECTION 2800]: SHUTDOWN & SANITIZING
# enable Firefox to clear items on shutdown
"privacy.sanitize.sanitizeOnShutdown" = true;

## SANITIZE ON SHUTDOWN: IGNORES "ALLOW" SITE EXCEPTIONS
# set/enforce what items to clear on shutdown
"privacy.clearOnShutdown.cache" = true;
"privacy.clearOnShutdown.downloads" = true;
"privacy.clearOnShutdown.formdata" = true;
"privacy.clearOnShutdown.history" = true;
"privacy.clearOnShutdown.sessions" = true;
"privacy.clearOnShutdown.siteSettings" = false;

## SANITIZE ON SHUTDOWN: RESPECTS "ALLOW" SITE EXCEPTIONS FF103+
# set "Cookies" and "Site Data" to clear on shutdown
"privacy.clearOnShutdown.cookies" = true;
"privacy.clearOnShutdown.offlineApps" = true;

## SANITIZE MANUAL: IGNORES "ALLOW" SITE EXCEPTIONS
# reset default items to clear with Ctrl-Shift-Del
"privacy.cpd.cache" = true;
"privacy.cpd.formdata" = true;
"privacy.cpd.history" = true;
"privacy.cpd.sessions" = true;
"privacy.cpd.offlineApps" = false;
"privacy.cpd.cookies" = false;

# reset default "Time range to clear" for "Clear Recent History"
# 0=everything, 1=last hour, 2=last two hours, 3=last four hours, 4=today
"privacy.sanitize.timeSpan" = 0;

### [SECTION 4000]: FPP (fingerprintingProtection)
# enable FPP in PB mode [FF114+]
"privacy.fingerprintingProtection.pbmode" = true;

# set global FPP overrides [FF114+]
#"privacy.fingerprintingProtection.overrides" = "";

### [SECTION 4500]: RFP (resistFingerprinting)

# enable RFP
"privacy.resistFingerprinting" = true;
"privacy.resistFingerprinting.pbmode" = true;

# set new window size rounding max values [FF55+]
"privacy.window.maxInnerWidth" = 1600;
"privacy.window.maxInnerHeight" = 900;

# disable mozAddonManager Web API [FF57+]
"privacy.resistFingerprinting.block_mozAddonManager" = true;

# enable RFP letterboxing [FF67+]
# "privacy.resistFingerprinting.letterboxing" = true;

# experimental RFP [FF91+]
"browser.display.use_system_colors" = false;

# enforce non-native widget theme
"widget.non-native-theme.enabled" = true;

# enforce links targeting new windows to open in a new tab instead
# 1=most recent window or tab, 2=new window, 3=new tab
"browser.link.open_newwindow" = 3;

# set all open window methods to abide by "browser.link.open_newwindow"
"browser.link.open_newwindow.restriction" = 0;

# disable WebGL (Web Graphics Library)
#"webgl.disabled" = true;
"webgl.disabled" = false;

### [SECTION 5000]: OPTIONAL OPSEC
# start Firefox in PB (Private Browsing) mode
#"browser.privatebrowsing.autostart" = true;

# disable memory cache
#"browser.cache.memory.enable" = false;
#"browser.cache.memory.capacity" = 0;

# disable saving passwords
"signon.rememberSignons" = false;

# disable permissions manager from writing to disk [FF41+] [RESTART]
"permissions.memory_only" = true;

# disable intermediate certificate caching [FF41+] [RESTART]
"security.nocertdb" = true;

# disable favicons in history and bookmarks
#"browser.chrome.site_icons" = false;

# exclude "Undo Closed Tabs" in Session Restore
#"browser.sessionstore.max_tabs_undo" = 0;

# disable resuming session from crash
#"browser.sessionstore.resume_from_crash" = false;

# disable "open with" in download dialog [FF50+]
#"browser.download.forbid_open_with" = true;

# disable location bar suggestion types
#"browser.urlbar.suggest.history" = false;
#"browser.urlbar.suggest.bookmark" = false;
#"browser.urlbar.suggest.openpage" = false;
#"browser.urlbar.suggest.topsites" = false;

# disable location bar dropdown
#"browser.urlbar.maxRichResults = 0;

# disable location bar autofill
#"browser.urlbar.autoFill" = false;

# disable browsing and download history
#"places.history.enabled" = false;

# discourage downloading to desktop
# 0=desktop, 1=downloads (default), 2=custom
#"browser.download.folderList" = 2;

# disable Form Autofill
#"extensions.formautofill.addresses.enabled" = false;
#"extensions.formautofill.creditCards.enabled" = false;

# limit events that can cause a pop-up
#"dom.popup_allowed_events" =  "click dblclick mousedown pointerdown";

# disable page thumbnail collection
#"browser.pagethumbnails.capturing_disabled" = true;

# disable Windows native notifications and use app notications instead [FF111+] [WINDOWS]
#"alerts.useSystemBackend.windows.notificationserver.enabled" = false;

# disable location bar using search
#"keyword.enabled" = false;

### [SECTION 5500]: OPTIONAL HARDENING
# disable all DRM content (EME: Encryption Media Extension)
#"media.eme.enabled" = false;
#"browser.eme.ui.enabled" = false;

# disable IPv6 if using a VPN
#"network.dns.disableIPv6" = true;

# control when to send a cross-origin referer
# 0=always (default), 1=only if base domains match, 2=only if hosts match
#"network.http.referer.XOriginPolicy" = 2;

# set DoH bootstrap address [FF89+]
#"network.trr.bootstrapAddr" = "10.75.0.1";

### [SECTION 6000]: DON'T TOUCH 
# enforce Firefox blocklist
"extensions.blocklist.enabled" = true;

# enforce no referer spoofing
"network.http.referer.spoofSource" = false;

# enforce a security delay on some confirmation dialogs such as install, open/save
"security.dialog_enable_delay" = 1000;

# enforce no First Party Isolation [FF51+]
"privacy.firstparty.isolate" = false;

# enforce SmartBlock shims (about:compat) [FF81+]
"extensions.webcompat.enable_shims" = true;

# enforce no TLS 1.0/1.1 downgrades
"security.tls.version.enable-deprecated" = false;

# enforce disabling of Web Compatibility Reporter [FF56+]
"extensions.webcompat-reporter.enabled" = false;

# enforce Quarantined Domains [FF115+]
"extensions.quarantinedDomains.enabled" = true;

### [SECTION 7000]: DON'T BOTHER
# disable APIs
"geo.enabled" = false;
#"full-screen-api.enabled" = false;

# set default permissions
# Location, Camera, Microphone, Notifications [FF58+] Virtual Reality [FF73+]
# 0=always ask (default), 1=allow, 2=block
"permissions.default.geo" = 2;
"permissions.default.camera" = 0;
"permissions.default.microphone" = 0;
"permissions.default.desktop-notification" = 2;
"permissions.default.xr" = 0;

# onions
"dom.securecontext.allowlist_onions" = true;
"network.http.referer.hideOnionSource" = true;

# referers
"network.http.sendRefererHeader" = 2;
"network.http.referer.trimmingPolicy" = 0;

# set the default Referrer Policy [FF59+]
# 0=no-referer, 1=same-origin, 2=strict-origin-when-cross-origin, 3=no-referrer-when-downgrade
"network.http.referer.defaultPolicy" = 2;
"network.http.referer.defaultPolicy.pbmode" = 2;

# disable HTTP Alternative Services [FF37+]
"network.http.altsvc.enabled" = false;

# disable website control over browser right-click context menu
#"dom.event.contextmenu.enabled" = false;

# disable Clipboard API
#"dom.event.clipboardevents.enabled" = false;

# disable System Add-on updates
"extensions.systemAddon.update.enabled" = true;

# DNT is enforced with Tracking Protection which is used in ETP Strict
"privacy.donottrackheader.enabled" = true;

# customize ETP settings
"network.cookie.cookieBehavior" = 5;
"privacy.fingerprintingProtection" = true;
"network.http.referer.disallowCrossSiteRelaxingDefault" = true;
"network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
"privacy.partition.network_state.ocsp_cache" = true;
"privacy.query_stripping.enabled" = true;
"privacy.query_stripping.enabled.pbmode" = true;
"privacy.trackingprotection.enabled" = true;
"privacy.globalprivacycontrol.enabled" = true;
"privacy.trackingprotection.socialtracking.enabled" = true;
"privacy.trackingprotection.cryptomining.enabled" = true;
"privacy.trackingprotection.fingerprinting.enabled" = true;

# disable service workers
#"dom.serviceWorkers.enabled" = false;

# disable Web Notifications [FF22+]
"dom.webnotifications.enabled" = false;

# disable Push Notifications [FF44+]
"dom.push.enabled" = false;

# disable WebRTC (Web Real-Time Communication)
"media.peerconnection.enabled" = false;

### [SECTION 8000]: DON'T BOTHER: FINGERPRINTING
# reset items useless for anti-fingerprinting
#(browser.display.use_document_fonts" = "";
#"browser.zoom.siteSpecific" = "";
#"device.sensors.enabled" = "";
#"dom.enable_performance" = "";
#"dom.enable_resource_timing" = "";
#"dom.gamepad.enabled" = "";
#"dom.maxHardwareConcurrency" = "";
#"dom.w3c_touch_events.enabled" = "";
#"dom.webaudio.enabled" = "";
#"font.system.whitelist" = "";
#"general.appname.override" = "";
#"general.appversion.override" = "";
#"general.buildID.override" = "";
#"general.oscpu.override" = "";
#"general.platform.override" = "";
#"general.useragent.override" = "";
#"media.navigator.enabled" = "";
#"media.ondevicechange.enabled" = "";
#"media.video_stats.enabled" = "";
#"media.webspeech.synth.enabled" = "";
#"ui.use_standins_for_native_colors" = "";
#"webgl.enable-debug-renderer-info" = "";

### [SECTION 9000]: MISC
# disable welcome noticesGoToIntranetSiteForSingleWordEntryInAddressBar

# disable What's New toolbar icon [FF69+]
"browser.messaging-system.whatsNewPanel.enabled" = false;

# disable search terms [FF110+]
"browser.urlbar.showSearchTerms.enabled" = false;

# mime system handler
"widget.use-xdg-desktop-portal.mime-handler" = 1;
"widget.use-xdg-desktop-portal.file-picker" = 1;

# go back with backspace
"browser.backspace_action" = 0;

# enable system titlebar
"browser.tabs.inTitlebar" = 0;

# remove import bookmars button from bookmark bar
"browser.bookmarks.restore_default_bookmarks" = false;

# automaticly deny cookies from cookie banners
# 1 (reject all) or 2 (reject all or fall back to accept all)
"cookiebanners.service.mode" = 1;
"cookiebanners.bannerClicking.enable" = true;
"cookiebanners.cookieInjector.enabled" = true;

# enable firefox translation
"browser.translations.panelShown" = true;
"browser.translations.neverTranslateLanguages" = "de";

# prefer system print dialog
"print.prefer_system_dialog" = true;

# warn on close
"browser.tabs.warnOnClose" = true;

# enable vaapi ffmpeg support
"media.ffmpeg.vaapi.enabled" = true;

# disable default browser check
"browser.shell.checkDefaultBrowser" = false;
"browser.shell.skipDefaultBrowserCheckOnFirstRun" = true;

# enable enterprise policies
"security.enterprise_roots.enabled" = true;

## FIREFOX ACCOUNTS
# disable firefox accounts
"identity.fxaccounts.enabled" = false;
"identity.fxaccounts.oauth.enabled" = false;
"identity.fxaccounts.toolbar.enabled" = false;

# setup custom sync server
"identity.sync.tokenserver.uri" = "https://firefoxsync.bitsync.icu/1.0/sync/1.5";

# disable pocket integration
"extensions.pocket.enabled" = false;

# disable welcome screen
"browser.aboutwelcome.enabled" = false;

# always display bookmarks toolbar
"browser.toolbars.bookmarks.visibility" = "always";

# customize firefox toolbars
"browser.uiCustomization.state" = {
  "placements" = {
    "widget-overflow-fixed-list" = [ ];
    "unified-extensions-area" = [
      "addon_darkreader_org-browser-action"
      "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
      "idcac-pub_guus_ninja-browser-action"
      "plasma-browser-integration_kde_org-browser-action"
    ];
    "nav-bar" = [
      "back-button"
      "forward-button"
      "stop-reload-button"
      "history-panelmenu"
      "urlbar-container"
      "search-container"
      "bookmarks-menu-button"
      "downloads-button"
      "privatebrowsing-button"
      "developer-button"
      "keepassxc-browser_keepassxc_org-browser-action"
      "floccus_handmadeideas_org-browser-action"
      "fxa-toolbar-menu-button"
      "addon_simplelogin-browser-action"
      "ublock0_raymondhill_net-browser-action"
      "unified-extensions-button"
    ];
    "toolbar-menubar" = [ "menubar-items" ];
    "TabsToolbar" = [ 
      "tabbrowser-tabs"
      "new-tab-button"
      "alltabs-button"
    ];
    "PersonalToolbar" = [ 
      "managed-bookmarks"
      "personal-bookmarks" 
    ];
  };
  "seen" = [
    "developer-button"
    "addon_simplelogin-browser-action"
    "addon_darkreader_org-browser-action"
    "idcac-pub_guus_ninja-browser-action"
    "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
    "floccus_handmadeideas_org-browser-action"
    "ublock0_raymondhill_net-browser-action"
    "keepassxc-browser_keepassxc_org-browser-action"
    "plasma-browser-integration_kde_org-browser-action"
  ];
  "dirtyAreaCache" = [
    "nav-bar"
    "PersonalToolbar"
    "unified-extensions-area"
    "TabsToolbar"
  ];
  "currentVersion" = 20;
  "newElementCount" = 8;
  };
};

in

{
  programs.firefox = {
    enable = true;
    package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { 
      pipewireSupport = true;
      alsaSupport = true;
      }) {});
    nativeMessagingHosts = with pkgs; [
      keepassxc
      libsForQt5.plasma-browser-integration
    ];

    policies = {
      DefaultDownloadDirectory = "\${home}/Downloads";

      DontCheckDefaultBrowser = true;
      EnterprisePoliciesEnabled = true;
      ExtensionSettings = {
        # Get Extension IDs about:debugging#/runtime/this-firefox

        #"{60f82f00-9ad5-4de5-b31c-b16a47c51558}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/cookie_quick_manager/latest.xpi";
        #};
        "addon@darkreader.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
        "@testpilot-containers" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/multi_account_containers/latest.xpi";
        };
        "floccus@handmadeideas.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/floccus/latest.xpi";
        };
        "idcac-pub@guus.ninja" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
        };
        #"1094918@gmail.com" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ins_downloader/latest.xpi";
        #};
        "keepassxc-browser@keepassxc.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc_browser/latest.xpi";
        };
        #"kiwix-html5-listed@kiwix.org" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latestkiwix_offline/latest.xpi";
        #};
        #"7esoorv3@alefvanoon.anonaddy.me" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
        #};
        #"{9efc0280-b125-400e-b53d-2d09d7effab4}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/mitaka/latest.xpi";
        #};
        #"{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
        #};
        "plasma-browser-integration@kde.org" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/plasma_integration/latest.xpi";
        };
        "addon@simplelogin" = {
          "installation_mode" = "normal_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/simplelogin/latest.xpi";
        };
        "{b11bea1f-a888-4332-8d8a-cec2be7d24b9}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/torproject-snowflake/latest.xpi";
        };
        "uBlock0@raymondhill.net" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        #"{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/user_agent_string_switcher/latest.xpi";
        #};
        #"{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/video_downloadhelper/latest.xpi";
        #};
        #"{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/vimium_ff/latest.xpi";
        #};
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
        };
        #"{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = {
        #  "installation_mode" = "normal_installed";
        #  "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/view_page_archive/latest.xpi";
        #};
      };

      #"uBlock0@raymondhill.net".adminSettings = {
      #  userSettings = rec {
      #    advancedUserEnabled = true;
      #    uiTheme = "auto";
      #    uiAccentCustom = true;
      #    cloudStorageEnabled = false;
      #    importedLists = [
      #      "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
      #    ];
      #    externalLists = lib.concatStringsSep "\n" importedLists;
      #    popupPanelSections = 63;
      #  };
      #  selectedFilterLists = [
      #    "user-filters"
      #    "ublock-filters"
      #    "ublock-badware"
      #    "ublock-privacy"
      #    "ublock-quick-fixes"
      #    "ublock-unbreak"
      #    "easylist"
      #    "adguard-spyware"
      #    "easyprivacy"
      #    "urlhaus-1"
      #    "plowe-0"
      #    "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
      #  ];
      #};

      #"keepassxc-browser@keepassxc.org".adminSettings = {
      #  autoReconnect = true;
      #  afterFillSorting = "sortByMatchingCredentials";
      #  afterFillSortingTotp = "sortByRelevantEntry";
      #  autoCompleteUsernames = true;
      #  showGroupNameInAutocomplete = true;
      #  autoFillAndSend = false;
      #  autoFillSingleEntry = false;
      #  autoFillSingleTotp = true;
      #  autoRetrieveCredentials = true;
      #  autoSubmit = true;
      #  checkUpdateKeePassXC = 0;
      #  clearCredentialsTimeout = 10;
      #  colorTheme = "system";
      #  credentialSorting = "sortByGroupAndTitle";
      #  defaultGroupAlwaysAsk = true;
      #  downloadFaviconAfterSave = true;
      #  passkeys = true;
      #  passkeysFallback = true;
      #  saveDomainOnly = false;
      #  showGettingStartedGuideAlert = true;
      #  showTroubleshootingGuideAlert = true;
      #  showLoginFormIcon = true;
      #  showLoginNotifications = true;
      #  showNotifications = true;
      #  useMonochromeToolbarIcon = false;
      #  showOTPIcon = true;
      #  useObserver = true;
      #  usePredefinedSites = true;
      #  usePasswordGeneratorIcons = true;
      #};

      #"{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".adminSettings = {
      #  scripts = {
      #    "Simple YouTube Age Restriction Bypass" = {
       #     custom = {
       #       origInclude = true;
       ##       origExclude = true;
       #       origMatch = true;
       #       origExcludeMatch = true;
       #       homepageURL = "https://github.com/zerodytrash/Simple-YouTube-Age-Restriction-Bypass?tab=readme-ov-file";
       #       lastInstallURL = "https://raw.githubusercontent.com/zerodytrash/Simple-YouTube-Age-Restriction-Bypass/main/dist/Simple-YouTube-Age-Restriction-Bypass.user.js";
       #     };
       #     config = {
       #       enabled = 1;
       #       shouldUpdate = 1;
       #       removed = 0;
       #     };
       #   };
       # };
       # settings = {
       #   isApplied = true;
       #   autoUpdate = 1;
       #   updateEnabledScriptsOnly = false;
       #   exportValues = true;
       #   closeAfterInstall = false;
       #   editAfterInstall = false;
       #   autoReload = true;
       #   importScriptData = false;
       #   importSettings = false;
       #   notifyUpdates = false;
       #   notifyUpdatesGlobal = false;
       #   defaultInjectInto = "auto";
       #   showAdvanced = true;
       # };
      #};

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };

      ManagedBookmarks = [
        {
          toplevel_name = "Managed";
        }
        {
          name = "NixOS Changelog";
          keyword = "changelog";
          url = "https://nixos.org/manual/nixos/unstable/release-notes";
          toolbar = true;
        }
        {
          name = "Nix Packages";
          keyword = "changelog";
          url = "https://search.nixos.org/packages";
          toolbar = true;
        }
        {
          name = "Nix Options";
          keyword = "changelog";
          url = "https://search.nixos.org/options";
          toolbar = true;
        }
        {
          name = "Home Manager Options";
          keyword = "changelog";
          url = "https://home-manager-options.extranix.com/";
          toolbar = true;
        }
        {
          name = "Work";
          children = [
            {
              name = "Proton";
              keyword = "proton";
              url = "https://account.proton.me/switch";
            }
          ];
        }
      ];

      SearchEngines = {
        #Add = [];
        Remove = [
          "Google"
          "Bing"
          "Amazon.de"
          #"DuckDuckGo"
          "eBay"
          "Ecosia"
          "LEO Eng-Deu"
          "Wikipedia (en)"
        ];
        #Default = "DuckDuckGo";
      };

      #Handlers = {};

      GoToIntranetSiteForSingleWordEntryInAddressBar = false;
      HardwareAcceleration = true;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      PopupBlocking.Default = true;
      RequestedLocales = [ "de-DE" "en-US" ];
    };

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        containers = {
          ChatGPT = {
            color = "red";
            icon = "fence";
            id = 2;
          };   
          Proton = {
            color = "blue";
            icon = "fingerprint";
            id = 3;
          };
        };
        settings = arkenfox-js;
        search = {
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@np" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };

            "Nix Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@no" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };

            "Home Manager Options" = {
              urls = [{
                template = "https://home-manager-options.extranix.com/";
                params = [
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@hm" ];
              iconUpdateURL = "https://icons.duckduckgo.com/ip3/home-manager-options.extranix.com.ico";
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
            };

            "Such-O-Mat" = {
              urls = [{ template = "https://searxng.bitsync.icu/search/{searchTerms}"; }];
              definedAliases = [ "@s" ];
              iconUpdateURL = "https://searxng.bitsync.icu/favicon";
            };

            "DuckDuckGo" = {
              urls = [{ template = "https://duckduckgo.com"; }];
              params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              definedAliases = [ "@d" ];
              iconUpdateURL = "https://icons.duckduckgo.com/ip3/duckduckgo.com.ico";
            };

            "Brave" = {
              urls = [{ template = "https://search.brave.com/search"; }];
              params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              definedAliases = [ "@b" ];
              iconUpdateURL = "https://icons.duckduckgo.com/ip3/search.brave.com.ico";
            };

            "Qwant" = {
              urls = [{ template = "https://www.qwant.com/"; }];
              params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              definedAliases = [ "@b" ];
              iconUpdateURL = "https://icons.duckduckgo.com/ip3/www.qwant.com.ico";
            };

            "Startpage" = {
              urls = [{ template = "https://www.startpage.com/sp/search"; }];
              params = [
                  { name = "query"; value = "{searchTerms}"; }
                ];
              definedAliases = [ "@sp" ];
              iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon--default.ico";
            };

            "MetaGer" = {
              urls = [{ template = "https://metager.org/meta/meta.ger3"; }];
              params = [
                  { name = "eingabe"; value = "{searchTerms}"; }
                ];
              definedAliases = [ "@m" ];
              iconUpdateURL = "https://icons.duckduckgo.com/ip3/metager.org.ico";
            };
          };

          order = [
            "Suck-O-Mat"
            "DuckDuckGo"
            "Brave"
            "Qwant"
            "Startpage"
            "MetaGer"
            "Nix Packages"
            "Nix Options"
            "Home Manager Options"
            "NixOS Wiki"
          ];

          default = "DuckDuckGo";
        };

        bookmarks = [
          {
            name = "wikipedia";
            tags = [ "wiki" ];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
          {
            name = "kernel.org";
            url = "https://www.kernel.org";
          }
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                name = "wiki";
                tags = [ "wiki" "nix" ];
                url = "https://nixos.wiki/";
              }
            ];
          }
        ];
      };

      work = {
        id = 1;
        containers = {
          ChatGPT = {
            color = "red";
            icon = "fence";
            id = 2;
          };   
          Proton = {
            color = "blue";
            icon = "fingerprint";
            id = 3;
          };
        };
        settings = {
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.backspace_action" = 0;
          #"webgl.disabled" = true;
          #"network.http.referer.XOriginPolicy" = 2;
          "security.OCSP.require" = false;
          "dom.security.https_only_mode" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "privacy.fingerprintingProtection" = true;
        };
      };
      
      school = {
        id = 2;
        containers = {
          Teams = {
            color = "red";
            icon = "fence";
            id = 1;
          };
          WebUntis = {
            color = "red";
            icon = "fence";
            id = 2;
          };
          Standardsicherung = {
            color = "red";
            icon = "fence";
            id = 3;
          };
        };
        settings = {
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.backspace_action" = 0;
          #"webgl.disabled" = true;
          #"network.http.referer.XOriginPolicy" = 2;
          "security.OCSP.require" = false;
          "dom.security.https_only_mode" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "privacy.fingerprintingProtection" = true;
        };
      };
      
      entertainment = {
        id = 3;
        containers = {
          Netflix = {
            color = "red";
            icon = "fence";
            id = 1;
          };
          Disney = {
            color = "red";
            icon = "fence";
            id = 2;
          };
          Twitch = {
            color = "red";
            icon = "fence";
            id = 3;
          };
          Instagram = {
            color = "red";
            icon = "fence";
            id = 4;
          };
        };
        settings = {
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.backspace_action" = 0;
          #"webgl.disabled" = true;
          #"network.http.referer.XOriginPolicy" = 2;
          "security.OCSP.require" = false;
          "dom.security.https_only_mode" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.sanitize.sanitizeOnShutdown" = false;
        };
      };

      privacy = {
        id = 4;
        settings = {
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.backspace_action" = 0;
          "webgl.disabled" = true;
          "network.http.referer.XOriginPolicy" = 2;
          "security.OCSP.require" = true;
          "dom.security.https_only_mode" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = true;
        };
      };

      hacking = {
        id = 5;
        settings = {
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.backspace_action" = 0;
          #"webgl.disabled" = true;
          #"network.http.referer.XOriginPolicy" = 2;
          "security.OCSP.require" = false;
          "dom.security.https_only_mode" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "privacy.fingerprintingProtection" = true;
        };
      };
    };
  };
}


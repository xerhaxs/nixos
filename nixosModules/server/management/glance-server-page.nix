{
  config,
  lib,
}:

let
  cfg = config.nixos.server.management.glance;
  homeDomain = config.nixos.server.network.nginx.domain;
  domain = config.nixos.site.domain;
  mailDomain = config.nixos.site.mailDomain;

  prometheus = "http://127.0.0.1:${toString config.services.prometheus.port}/api/v1/query";
  alertmanager = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}";
  grafana = "https://grafana.${homeDomain}/d/security-updates";

  app = title: subdomain: icon: {
    inherit title icon;
    url = "https://${subdomain}.${homeDomain}";
  };

  publicApp = title: subdomain: icon: {
    inherit title icon;
    url = "https://${subdomain}.${domain}";
  };

  monitor = title: sites: {
    type = "monitor";
    cache = "1m";
    inherit title sites;
  };

  stat = value: label: ''
    <div><div class="color-highlight size-h3">${value}</div><div class="size-h6">${label}</div></div>
  '';

  # Glance only fails on a non-2xx status if the body is not JSON, a 401 with a JSON or empty body
  # renders an empty widget. Shows the status instead (0: no response, see the journal of glance).
  httpError = response: ''
    {{ if or (lt ${response}.StatusCode 200) (ge ${response}.StatusCode 300) }}
      <p class="color-negative">HTTP {{ ${response}.StatusCode }}{{ if or (eq ${response}.StatusCode 401) (eq ${response}.StatusCode 403) }}: check the token in sops glance{{ end }}</p>
    {{ end }}
  '';

  # Metrics of the other hosts are already in Prometheus, this needs no agent or open port on them.
  hostStats =
    title: instance:
    let
      metric = name: expr: ''label_replace(${expr}, "metric", "${name}", "", "")'';
      selector = ''instance="${instance}"'';
      disk = ''mountpoint="/persistent"'';
    in
    {
      type = "custom-api";
      inherit title;
      cache = "1m";
      url = prometheus;
      parameters.query = lib.concatStringsSep " or " [
        (metric "Status" ''up{job="node",${selector}}'')
        (metric "CPU" ''100 * (1 - avg(rate(node_cpu_seconds_total{mode="idle",${selector}}[5m])))'')
        (metric "RAM" "100 * (1 - node_memory_MemAvailable_bytes{${selector}} / node_memory_MemTotal_bytes{${selector}})")
        (metric "Disk" "100 * (1 - node_filesystem_avail_bytes{${selector},${disk}} / node_filesystem_size_bytes{${selector},${disk}})")
        (metric "Uptime" "(time() - node_boot_time_seconds{${selector}}) / 86400")
      ];
      template = ''
        {{ $metrics := sortByString "metric.metric" "asc" (.JSON.Array "data.result") }}
        {{ if eq (len $metrics) 0 }}
          <p class="color-negative">No data in Prometheus</p>
        {{ else }}
          <div class="flex justify-between text-center">
          {{ range $metrics }}
            {{ $name := .String "metric.metric" }}
            {{ $value := .Float "value.1" | toInt }}
            {{ if eq $name "Status" }}
              ${stat ''{{ if eq $value 1 }}<span class="color-positive">online</span>{{ else }}<span class="color-negative">offline</span>{{ end }}'' "Status"}
            {{ else if eq $name "Uptime" }}
              ${stat "{{ $value }} d" "Uptime"}
            {{ else }}
              ${stat "{{ $value }} %" "{{ $name }}"}
            {{ end }}
          {{ end }}
          </div>
        {{ end }}
      '';
    };

  alerts = {
    type = "custom-api";
    title = "Active Alerts";
    title-url = "https://grafana.${homeDomain}/alerting";
    cache = "1m";
    url = "${alertmanager}/api/v2/alerts?active=true&silenced=false&inhibited=false";
    template = ''
      {{ $alerts := .JSON.Array "" }}
      {{ if eq (len $alerts) 0 }}
        <p class="color-positive">No active alerts</p>
      {{ else }}
        <ul class="list list-gap-10 collapsible-container" data-collapse-after="5">
        {{ range $alerts }}
          <li>
            <div class="{{ if eq (.String "labels.severity") "critical" }}color-negative{{ else }}color-highlight{{ end }}">{{ .String "labels.alertname" }}</div>
            <div class="size-h6">{{ .String "annotations.summary" }}</div>
          </li>
        {{ end }}
        </ul>
      {{ end }}
    '';
  };

  vulnerabilities = {
    type = "custom-api";
    title = "CVEs and Updates";
    title-url = grafana;
    cache = "10m";
    url = prometheus;
    parameters.query = ''nixos_cve_open{severity=~"Critical|High"}'';
    template = ''
      {{ $updates := newRequest "${prometheus}" | withParameter "query" "sum(nixos_update_available)" | getResponse }}
      {{ $reboot := newRequest "${prometheus}" | withParameter "query" "sum(nixos_reboot_required)" | getResponse }}
      <div class="flex justify-between text-center margin-bottom-10">
        ${stat ''{{ $updates.JSON.Float "data.result.0.value.1" | toInt }}'' "Updates"}
        ${stat ''{{ $reboot.JSON.Float "data.result.0.value.1" | toInt }}'' "Reboots"}
      </div>
      <ul class="list list-gap-6">
      {{ range sortByString "metric.instance" "asc" (.JSON.Array "data.result") }}
        {{ if ne (.Float "value.1" | toInt) 0 }}
          <li class="flex justify-between">
            <span>{{ .String "metric.instance" | trimPrefix "NixOS-" }}</span>
            <span class="{{ if eq (.String "metric.severity") "Critical" }}color-negative{{ else }}color-highlight{{ end }}">{{ .Float "value.1" | toInt }} {{ .String "metric.severity" }}</span>
          </li>
        {{ end }}
      {{ end }}
      </ul>
      <p class="size-h6 margin-top-10">Candidates matched by name and version, not every hit affects you.</p>
    '';
  };

  minecraft = {
    type = "custom-api";
    title = "Flolserver";
    title-url = "https://bluemap.${domain}";
    cache = "2m";
    url = "https://api.mcstatus.io/v2/status/java/flolserver.${domain}:25565";
    template = ''
      {{ if .JSON.Bool "online" }}
        <div class="flex justify-between text-center">
          ${stat ''<span class="color-positive">online</span>'' "Status"}
          ${stat ''{{ .JSON.Int "players.online" }} / {{ .JSON.Int "players.max" }}'' "Players"}
          ${stat ''{{ .JSON.String "version.name_clean" }}'' "Version"}
        </div>
      {{ else }}
        <p class="color-negative">Offline</p>
      {{ end }}
    '';
  };

  jellyfin = {
    type = "custom-api";
    title = "Jellyfin";
    title-url = "https://jellyfin.${homeDomain}";
    cache = "2m";
    url = "http://127.0.0.1:8096/Sessions?ActiveWithinSeconds=120";
    # Jellyfin 12 turned off the legacy X-Emby-Token header (EnableLegacyAuthorization).
    headers.Authorization = "MediaBrowser Token=\${ENV_JELLYFIN_TOKEN}";
    template = ''
      ${httpError ".Response"}
      {{ range .JSON.Array "" }}
        {{ if .Exists "NowPlayingItem" }}
          <p class="color-positive">{{ .String "UserName" }}: {{ .String "NowPlayingItem.Name" }}</p>
        {{ end }}
      {{ end }}
      {{ $latest := newRequest "http://127.0.0.1:8096/Items"
        | withHeader "Authorization" "MediaBrowser Token=''${ENV_JELLYFIN_TOKEN}"
        | withParameter "Recursive" "true"
        | withParameter "IncludeItemTypes" "Movie,Episode"
        | withParameter "SortBy" "DateCreated"
        | withParameter "SortOrder" "Descending"
        | withParameter "Limit" "6"
        | getResponse }}
      ${httpError "$latest.Response"}
      <ul class="list list-gap-6">
      {{ range $latest.JSON.Array "Items" }}
        <li>{{ if .Exists "SeriesName" }}{{ .String "SeriesName" }}: {{ end }}{{ .String "Name" }}</li>
      {{ else }}
        <li class="color-subdue">No recent items</li>
      {{ end }}
      </ul>
    '';
  };

  calendar =
    let
      request = port: key: ''
        newRequest "http://127.0.0.1:${toString port}/api/v3/calendar"
          | withHeader "X-Api-Key" "''${${key}}"
          | withParameter "start" $start
          | withParameter "end" $end
          | withParameter "includeSeries" "true"
          | getResponse
      '';
    in
    {
      type = "custom-api";
      title = "New This Week";
      cache = "1h";
      template = ''
        {{ $start := now | formatTime "2006-01-02" }}
        {{ $end := offsetNow "168h" | formatTime "2006-01-02" }}
        {{ $episodes := ${request 8989 "ENV_SONARR_KEY"} }}
        {{ $movies := ${request 7878 "ENV_RADARR_KEY"} }}
        <ul class="list list-gap-6 collapsible-container" data-collapse-after="8">
        {{ range $episodes.JSON.Array "" }}
          <li>{{ .String "series.title" }} S{{ .Int "seasonNumber" }}E{{ .Int "episodeNumber" }}</li>
        {{ end }}
        {{ range $movies.JSON.Array "" }}
          <li>{{ .String "title" }}</li>
        {{ end }}
        </ul>
      '';
    };

  miniflux = {
    type = "custom-api";
    title = "RSS Unread";
    title-url = "https://rss.${domain}";
    cache = "10m";
    url = "https://rss.${domain}/v1/categories?counts=true";
    headers.X-Auth-Token = "\${ENV_MINIFLUX_TOKEN}";
    template = ''
      ${httpError ".Response"}
      {{ $unread := 0 }}
      <ul class="list list-gap-6">
      {{ range sortByInt "total_unread" "desc" (.JSON.Array "") }}
        {{ if gt (.Int "total_unread") 0 }}
          {{ $unread = add $unread (.Int "total_unread") }}
          <li class="flex justify-between"><span>{{ .String "title" }}</span><span class="color-highlight">{{ .Int "total_unread" }}</span></li>
        {{ end }}
      {{ end }}
      {{ if eq $unread 0 }}
        <li class="color-subdue">No unread entries</li>
      {{ end }}
      </ul>
    '';
  };

  homeassistant = {
    type = "custom-api";
    title = "Home Assistant";
    title-url = "https://homeassistant.${homeDomain}";
    cache = "5m";
    url = "http://127.0.0.1:8123/api/states";
    headers.Authorization = "Bearer \${ENV_HA_TOKEN}";
    template = ''
      ${httpError ".Response"}
      <ul class="list list-gap-6">
      {{ range .JSON.Array "" }}
        {{ $id := .String "entity_id" }}
        {{ if or ${
          lib.concatMapStringsSep " " (entity: ''(eq $id "${entity}")'') cfg.homeassistant.entities
        } }}
          <li class="flex justify-between" style="gap: 1rem"><span>{{ .String "attributes.friendly_name" | trimPrefix "GoodWe " }}</span><span class="color-highlight" style="white-space: nowrap">{{ .String "state" }} {{ .String "attributes.unit_of_measurement" }}</span></li>
        {{ end }}
      {{ end }}
      </ul>
    '';
  };
in

{
  name = "Server";
  columns = [
    {
      size = "small";
      widgets = [
        alerts
        vulnerabilities
      ]
      ++ lib.optional cfg.miniflux.enable miniflux
      ++ lib.optional (cfg.homeassistant.enable && cfg.homeassistant.entities != [ ]) homeassistant;
    }
    {
      size = "full";
      widgets = [
        {
          type = "server-stats";
          title = "NixOS-Server1";
          servers = [
            {
              type = "local";
              name = "NixOS-Server1";
            }
          ];
        }
        (monitor "Server1: Management" [
          (app "Cockpit" "cockpit" "auto-invert di:cockpit")
          (app "Grafana" "grafana" "di:grafana")
          (app "Home Assistant" "homeassistant" "di:home-assistant")
          (app "HomeBox" "homebox" "di:homebox")
          (app "Pi-hole" "pihole" "di:pi-hole")
          (app "Forgejo and Wiki" "forgejo" "di:forgejo")
          (app "Syncthing" "syncthing" "di:syncthing")
        ])
        (monitor "Server1: Media" [
          (app "Jellyfin" "jellyfin" "di:jellyfin")
          (app "Sonarr" "sonarr" "di:sonarr")
          (app "Radarr" "radarr" "di:radarr")
          (app "Lidarr" "lidarr" "di:lidarr")
          (app "Readarr" "readarr" "di:readarr")
          (app "SABnzbd" "sabnzbd" "di:sabnzbd")
          (app "NZBHydra2" "nzbhydra" "di:nzbhydra2")
          (app "Kiwix" "kiwix" "auto-invert di:kiwix")
        ])
        (monitor "Server1: Tools" [
          (app "Ollama" "ollama" "auto-invert di:ollama")
          (app "ComfyUI" "comfyui" "di:comfyui")
          (app "SearXNG" "searxng" "di:searxng")
          # API only or no own start page: the root answers 400 (LanguageTool) or 404 (Matrix, Redlib),
          # check a page that always answers instead.
          (
            (app "LanguageTool" "languagetool" "sh:languagetool")
            // {
              check-url = "https://languagetool.${homeDomain}/v2/languages";
            }
          )
          (app "LibreTranslate" "libretranslate" "auto-invert di:libretranslate")
          (app "Linkwarden" "linkwarden" "sh:linkwarden")
          (app "Radicale" "radicale" "di:radicale")
          (app "Invidious" "invidious" "di:invidious")
          (
            (app "Redlib" "libreddit" "di:redlib")
            // {
              check-url = "https://libreddit.${homeDomain}/settings";
            }
          )
          (app "Networking Toolbox" "networkingtoolbox" "di:networking-toolbox-dark")
        ])
        (hostStats "NixOS-ServerPublic" "NixOS-ServerPublic")
        (monitor "ServerPublic" [
          {
            title = "Mail (Stalwart)";
            url = "https://mail.${mailDomain}";
            icon = "di:stalwart";
          }
          (publicApp "CryptPad" "cryptpad" "di:cryptpad")
          (
            (publicApp "Matrix" "matrix" "di:matrix-light")
            // {
              check-url = "https://matrix.${domain}/_matrix/client/versions";
            }
          )
          (publicApp "ntfy" "push" "di:ntfy")
          (publicApp "Miniflux" "rss" "di:miniflux")
        ])
        (hostStats "NixOS-ServerGaming" "NixOS-ServerGaming")
        minecraft
        (monitor "ServerGaming" [
          (publicApp "BlueMap" "bluemap" "di:minecraft")
        ])
        # hosts/NixOS-ServerGaming/temp, removed later.
        (monitor "ServerGaming: Test" [
          (publicApp "Countdown" "countdown" "auto-invert di:cronicle")
        ])
      ];
    }
    {
      size = "small";
      widgets =
        lib.optional cfg.jellyfin.enable jellyfin
        ++ lib.optional cfg.calendar.enable calendar
        ++ [
          {
            type = "bookmarks";
            title = "Wiki";
            groups = [
              {
                links = [
                  {
                    title = "Forgejo-Wiki";
                    url = "https://forgejo.${homeDomain}/jf/wiki/wiki";
                  }
                  {
                    title = "Security and Updates";
                    url = grafana;
                  }
                ];
              }
            ];
          }
        ];
    }
  ];
}

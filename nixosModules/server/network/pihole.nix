{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.pihole = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable PiHole.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.pihole.enable {
    services = {
        pihole-ftl = {
          enable = true;
          
          openFirewallDNS = true;
          openFirewallDHCP = false;
          openFirewallWebserver = false;

          lists = [
            {
              url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
              type = "block";
              enabled = true;
              description = "StevenBlack";
            }
            {
              url = "https://blocklistproject.github.io/Lists/malware.txt";
              type = "block";
              enabled = true;
              description = "Malware";
            }
            {
              url = "https://blocklistproject.github.io/Lists/phishing.txt";
              type = "block";
              enabled = true;
              description = "Phishing";
            }
            {
              url = "https://blocklistproject.github.io/Lists/ransomware.txt";
              type = "block";
              enabled = true;
              description = "Ransomware";
            }
            {
              url = "https://blocklistproject.github.io/Lists/scam.txt";
              type = "block";
              enabled = true;
              description = "Scam";
            }
            {
              url = "https://blocklistproject.github.io/Lists/tiktok.txt";
              type = "block";
              enabled = true;
              description = "TikTok";
            }
            {
              url = "https://blocklistproject.github.io/Lists/tracking.txt";
              type = "block";
              enabled = true;
              description = "Tracking";
            }
            {
              url = "https://blocklistproject.github.io/Lists/smart-tv.txt";
              type = "block";
              enabled = true;
              description = "Smart-TV";
            }
            {
              url = "https://blocklistproject.github.io/Lists/adobe.txt";
              type = "block";
              enabled = true;
              description = "Adobe";
            }
            {
              url = "https://perflyst.github.io/PiHoleBlocklist/AmazonFireTV.txt";
              type = "block";
              enabled = true;
              description = "AmazonFireTV";
            }
          ];

          privacyLevel = 0;
          settings = {
            dns = {
              # Array of upstream DNS servers used by Pi-hole
              # Example: [ "8.8.8.8", "127.0.0.1#5335", "docker-resolver" ]
              #
              # Possible values are:
              #     array of IP addresses and/or hostnames, optionally with a port (#...)
              upstreams = [
                "9.9.9.11"
                "2620:fe::11"
                "149.112.112.11"
                "2620:fe::fe:11"
                "2606:4700:4700::1001"
                "2606:4700:4700::1111"
                "1.0.0.1"
                "1.1.1.1"
              ]; ### CHANGED, default = []

              # Use this option to control deep CNAME inspection. Disabling it might be beneficial
              # for very low-end devices
              CNAMEdeepInspect = true;

              # Should _esni. subdomains be blocked by default? Encrypted Server Name Indication
              # (ESNI) is certainly a good step into the right direction to enhance privacy on the
              # web. It prevents on-path observers, including ISPs, coffee shop owners and
              # firewalls, from intercepting the TLS Server Name Indication (SNI) extension by
              # encrypting it. This prevents the SNI from being used to determine which websites
              # users are visiting.
              # ESNI will obviously cause issues for pixelserv-tls which will be unable to generate
              # matching certificates on-the-fly when it cannot read the SNI. Cloudflare and Firefox
              # are already enabling ESNI. According to the IEFT draft (link above), we can easily
              # restore piselserv-tls's operation by replying NXDOMAIN to _esni. subdomains of
              # blocked domains as this mimics a "not configured for this domain" behavior.
              blockESNI = true;

              # Should we overwrite the query source when client information is provided through
              # EDNS0 client subnet (ECS) information? This allows Pi-hole to obtain client IPs even
              # if they are hidden behind the NAT of a router. This feature has been requested and
              # discussed on Discourse where further information how to use it can be found:
              # https://discourse.pi-hole.net/t/support-for-add-subnet-option-from-dnsmasq-ecs-edns0-client-subnet/35940
              EDNS0ECS = true;

              # Should FTL hide queries made by localhost?
              ignoreLocalhost = false;

              # Should FTL analyze and show internally generated DNSSEC queries?
              showDNSSEC = true;

              # Should FTL analyze *only* A and AAAA queries?
              analyzeOnlyAandAAAA = false;

              # Controls whether and how FTL will reply with for address for which a local interface
              # exists. Changing this setting causes FTL to restart.
              #
              # Possible values are:
              #   - "NONE"
              #       Pi-hole will not respond automatically on PTR requests to local interface
              #       addresses. Ensure pi.hole and/or hostname records exist elsewhere.
              #   - "HOSTNAME"
              #       Serve the machine's hostname. The hostname is queried from the kernel through
              #       uname(2)->nodename. If the machine has multiple network interfaces, it can
              #       also have multiple nodenames. In this case, it is unspecified and up to the
              #       kernel which one will be returned. On Linux, the returned string is what has
              #       been set using sethostname(2) which is typically what has been set in
              #       /etc/hostname.
              #   - "HOSTNAMEFQDN"
              #       Serve the machine's hostname (see limitations above) as fully qualified domain
              #       by adding the local domain. If no local domain has been defined (config option
              #       dns.domain), FTL tries to query the domain name from the kernel using
              #       getdomainname(2). If this fails, FTL appends ".no_fqdn_available" to the
              #       hostname.
              #   - "PI.HOLE"
              #       Respond with "pi.hole".
              piholePTR = "PI.HOLE";

              # How should FTL handle queries when the gravity database is not available?
              #
              # Possible values are:
              #   - "BLOCK"
              #       Block all queries when the database is busy.
              #   - "ALLOW"
              #       Allow all queries when the database is busy.
              #   - "REFUSE"
              #       Refuse all queries which arrive while the database is busy.
              #   - "DROP"
              #       Just drop the queries, i.e., never reply to them at all. Despite "REFUSE"
              #       sounding similar to "DROP", it turned out that many clients will just
              #       immediately retry, causing up to several thousands of queries per second. This
              #       does not happen in "DROP" mode.
              replyWhenBusy = "ALLOW";

              # FTL's internal TTL to be handed out for blocked queries in seconds. This settings
              # allows users to select a value different from the dnsmasq config option local-ttl.
              # This is useful in context of locally used hostnames that are known to stay constant
              # over long times (printers, etc.).
              # Note that large values may render whitelisting ineffective due to client-side
              # caching of blocked queries.
              blockTTL = 2;

              # Array of custom DNS records
              # Example: hosts = [ "127.0.0.1 mylocal", "192.168.0.1 therouter" ]
              #
              # Possible values are:
              #     Array of custom DNS records each one in HOSTS form: "IP HOSTNAME"
              hosts = [
                "10.75.0.10 proxmox.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 freshrss.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 homepage.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 jellyfin.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 nas.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 nextcloud.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 rss.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 syncthing.${config.nixos.server.network.nginx.domain}"
                "10.75.0.20 truenas.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 gitea.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 invidious.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 kiwix.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 libreddit.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 nitter.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 ollama.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 pihole.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 searx.${config.nixos.server.network.nginx.domain}"
                "10.75.0.21 searxng.${config.nixos.server.network.nginx.domain}"
                "10.75.0.23 lidarr.${config.nixos.server.network.nginx.domain}"
                "10.75.0.23 nzbhydra.${config.nixos.server.network.nginx.domain}"
                "10.75.0.23 radarr.${config.nixos.server.network.nginx.domain}"
                "10.75.0.23 readarr.${config.nixos.server.network.nginx.domain}"
                "10.75.0.23 sabnzbd.${config.nixos.server.network.nginx.domain}"
                "10.75.0.23 sonarr.${config.nixos.server.network.nginx.domain}"
                "10.75.0.25 haos.${config.nixos.server.network.nginx.domain}"
                "10.75.0.25 homeassistant.${config.nixos.server.network.nginx.domain}"
                "10.75.0.30 bluemap.${config.nixos.server.network.nginx.domain}"
                "10.75.0.30 flolserver.${config.nixos.server.network.nginx.domain}"
                "10.75.0.30 map.${config.nixos.server.network.nginx.domain}"
                "10.75.0.30 pufferpanel.${config.nixos.server.network.nginx.domain}"
              ]; ### CHANGED, default = []

              # If set, A and AAAA queries for plain names, without dots or domain parts, are never
              # forwarded to upstream nameservers
              domainNeeded = false;

              # If set, the domain is added to simple names (without a period) in /etc/hosts in the
              # same way as for DHCP-derived names
              expandHosts = false;

              # The DNS domain used by your Pi-hole.
              #
              # This DNS domain is purely local. FTL may answer queries from its local cache and
              # configuration but *never* forwards any requests upstream *unless* you have
              # configured a dns.revServer exactly for this domain. In the latter case, all queries
              # for this domain are sent exclusively to this server (including reverse lookups).
              #
              # For DHCP, this has two effects; firstly it causes the DHCP server to return the
              # domain to any hosts which request it, and secondly it sets the domain which it is
              # legal for DHCP-configured hosts to claim. The intention is to constrain hostnames so
              # that an untrusted host on the LAN cannot advertise its name via DHCP as e.g.
              # "google.com" and capture traffic not meant for it. If no domain suffix is specified,
              # then any DHCP hostname with a domain part (ie with a period) will be disallowed and
              # logged. If a domain is specified, then hostnames with a domain part are allowed,
              # provided the domain part matches the suffix. In addition, when a suffix is set then
              # hostnames without a domain part have the suffix added as an optional domain part.
              # For instance, we can set domain=mylab.com and have a machine whose DHCP hostname is
              # "laptop". The IP address for that machine is available both as "laptop" and
              # "laptop.mylab.com".
              #
              # You can disable setting a domain by setting this option to an empty string.
              #
              # Possible values are:
              #     <any valid domain>
              domain = "pi.hole"; ### CHANGED, default = "lan"

              # Should all reverse lookups for private IP ranges (i.e., 192.168.x.y, etc) which are
              # not found in /etc/hosts or the DHCP leases file be answered with "no such domain"
              # rather than being forwarded upstream?
              bogusPriv = true;

              # Validate DNS replies using DNSSEC?
              dnssec = true;

              # Interface to use for DNS (see also dnsmasq.listening.mode) and DHCP (if enabled)
              #
              # Possible values are:
              #     a valid interface name
              #interface = "eth0";

              # Add A, AAAA and PTR records to the DNS. This adds one or more names to the DNS with
              # associated IPv4 (A) and IPv6 (AAAA) records
              #
              # Possible values are:
              #     <name>[,<name>....],[<IPv4-address>],[<IPv6-address>][,<TTL>]
              hostRecord = "";

              # Pi-hole interface listening modes
              #
              # Possible values are:
              #   - "LOCAL"
              #       Allow only local requests. This setting accepts DNS queries only from hosts
              #       whose address is on a local subnet, i.e., a subnet for which an interface
              #       exists on the server. It is intended to be set as a default on installation,
              #       to allow unconfigured installations to be useful but also safe from being used
              #       for DNS amplification attacks if (accidentally) running public.
              #   - "SINGLE"
              #       Permit all origins, accept only on the specified interface. Respond only to
              #       queries arriving on the specified interface. The loopback (lo) interface is
              #       automatically added to the list of interfaces to use when this option is used.
              #       Make sure your Pi-hole is properly firewalled!
              #   - "BIND"
              #       By default, FTL binds the wildcard address. If this is not what you want, you
              #       can use this option as it forces FTL to really bind only the interfaces it is
              #       listening on. Note that this may result in issues when the interface may go
              #       down (cable unplugged, etc.). About the only time when this is useful is when
              #       running another nameserver on the same port on the same machine. This may also
              #       happen if you run a virtualization API such as libvirt. When this option is
              #       used, IP alias interface labels (e.g. enp2s0:0) are checked rather than
              #       interface names.
              #   - "ALL"
              #       Permit all origins, accept on all interfaces. Make sure your Pi-hole is
              #       properly firewalled! This truly allows any traffic to be replied to and is a
              #       dangerous thing to do as your Pi-hole could become an open resolver. You
              #       should always ask yourself if the first option doesn't work for you as well.
              #   - "NONE"
              #       Do not add any configuration concerning the listening mode to the dnsmasq
              #       configuration file. This is useful if you want to manually configure the
              #       listening mode in auxiliary configuration files. This option is really meant
              #       for advanced users only, support for this option may be limited.
              listeningMode = "LOCAL"; ### CHANGED (env), default = "LOCAL"

              # Log DNS queries and replies to pihole.log
              queryLogging = true;

              # List of CNAME records which indicate that <cname> is really <target>. If the <TTL> is
              # given, it overwrites the value of local-ttl
              #
              # Possible values are:
              #     Array of CNAMEs each on in one of the following forms: "<cname>,<target>[,<TTL>]"
              cnameRecords = [];

              # Port used by the DNS server
              #port = 53;

              # Reverse server (former also called "conditional forwarding") feature
              # Array of reverse servers each one in one of the following forms:
              # "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]"
              #
              # Individual components:
              #
              # <enabled>: either "true" or "false"
              #
              # <ip-address>[/<prefix-len>]: Address range for the reverse server feature in CIDR
              # notation. If the prefix length is omitted, either 32 (IPv4) or 128 (IPv6) are
              # substituted (exact address match). This is almost certainly not what you want here.
              # Example: "192.168.0.0/24" for the range 192.168.0.1 - 192.168.0.255
              #
              # <server>[#<port>]: Target server to be used for the reverse server feature
              # Example: "192.168.0.1#53"
              #
              # <domain>: Domain used for the reverse server feature (e.g., "fritz.box")
              # Example: "fritz.box"
              #
              # Possible values are:
              #     array of reverse servers each one in one of the following forms:
              #     "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]", e.g.,
              #     "true,192.168.0.0/24,192.168.0.1,fritz.box"
              revServers = [
                "true,10.75.0.0/24,fritz.box"
              ]; ### CHANGED, default = []

              cache = {
                # Cache size of the DNS server. Note that expiring cache entries naturally make room
                # for new insertions over time. Setting this number too high will have an adverse
                # effect as not only more space is needed, but also lookup speed gets degraded in the
                # 10,000+ range. dnsmasq may issue a warning when you go beyond 10,000+ cache entries.
                size = 10000;

                # Query cache optimizer: If a DNS name exists in the cache, but its time-to-live has
                # expired only recently, the data will be used anyway (a refreshing from upstream is
                # triggered). This can improve DNS query delays especially over unreliable Internet
                # connections. This feature comes at the expense of possibly sometimes returning
                # out-of-date data and less efficient cache utilization, since old data cannot be
                # flushed when its TTL expires, so the cache becomes mostly least-recently-used. To
                # mitigate issues caused by massively outdated DNS replies, the maximum overaging of
                # cached records is limited. We strongly recommend staying below 86400 (1 day) with
                # this option.
                # Setting the TTL excess time to zero will serve stale cache data regardless how long
                # it has expired. This is not recommended as it may lead to stale data being served
                # for a long time. Setting this option to any negative value will disable this feature
                # altogether.
                optimizer = 3600;

                # This setting allows you to specify the TTL used for queries blocked upstream. Once
                # the TTL expires, the query will be forwarded to the upstream server again to check
                # if the block is still valid. Defaults to caching for one day (86400 seconds).
                # Setting this value to zero disables caching of queries blocked upstream.
                upstreamBlockedTTL = 86400;
              };

              blocking = {
                # Should FTL block queries?
                active = true;

                # How should FTL reply to blocked queries?
                #
                # Possible values are:
                #   - "NULL"
                #       In NULL mode, which is both the default and recommended mode for Pi-hole
                #       FTLDNS, blocked queries will be answered with the "unspecified address"
                #       (0.0.0.0 or ::). The "unspecified address" is a reserved IP address specified
                #       by RFC 3513 - Internet Protocol Version 6 (IPv6) Addressing Architecture,
                #       section 2.5.2.
                #   - "IP_NODATA_AAAA"
                #       In IP-NODATA-AAAA mode, blocked queries will be answered with the local IPv4
                #       addresses of your Pi-hole. Blocked AAAA queries will be answered with
                #       NODATA-IPV6 and clients will only try to reach your Pi-hole over its static
                #       IPv4 address.
                #   - "IP"
                #       In IP mode, blocked queries will be answered with the local IP addresses of
                #       your Pi-hole.
                #   - "NX"
                #       In NXDOMAIN mode, blocked queries will be answered with an empty response
                #       (i.e., there won't be an answer section) and status NXDOMAIN. A NXDOMAIN
                #       response should indicate that there is no such domain to the client making the
                #       query.
                #   - "NODATA"
                #       In NODATA mode, blocked queries will be answered with an empty response (no
                #       answer section) and status NODATA. A NODATA response indicates that the domain
                #       exists, but there is no record for the requested query type.
                mode = "NULL";

                # Should FTL enrich blocked replies with EDNS0 information?
                #
                # Possible values are:
                #   - "NONE"
                #       In NONE mode, no additional EDNS information is added to blocked queries
                #   - "CODE"
                #       In CODE mode, blocked queries will be enriched with EDNS info-code BLOCKED (15)
                #   - "TEXT"
                #       In TEXT mode, blocked queries will be enriched with EDNS info-code BLOCKED (15)
                #       and a text message describing the reason for the block
                edns = "TEXT";
              };

              specialDomains = {
                # Should Pi-hole always reply with NXDOMAIN to A and AAAA queries of
                # use-application-dns.net to disable Firefox automatic DNS-over-HTTP? This is
                # following the recommendation on
                # https://support.mozilla.org/en-US/kb/configuring-networks-disable-dns-over-https
                mozillaCanary = true;

                # Should Pi-hole always reply with NXDOMAIN to A and AAAA queries of mask.icloud.com
                # and mask-h2.icloud.com to disable Apple's iCloud Private Relay to prevent Apple
                # devices from bypassing Pi-hole? This is following the recommendation on
                # https://developer.apple.com/support/prepare-your-network-for-icloud-private-relay
                iCloudPrivateRelay = true;

                # Should Pi-hole always reply with NODATA to all queries to zone resolver.arpa to
                # prevent devices from bypassing Pi-hole using Discovery of Designated Resolvers? This
                # is based on recommendations at the end of RFC 9462, section 4.
                designatedResolver = true;
              };

              reply = {
                host = {
                  # Use a specific IPv4 address for the Pi-hole host? By default, FTL determines the
                  # address of the interface a query arrived on and uses this address for replying to A
                  # queries with the most suitable address for the requesting client. This setting can
                  # be used to use a fixed, rather than the dynamically obtained, address when Pi-hole
                  # responds to the following names: [ "pi.hole", "<the device's hostname>",
                  # "pi.hole.<local domain>", "<the device's hostname>.<local domain>" ]
                  force4 = false;

                  # Custom IPv4 address for the Pi-hole host
                  #
                  # Possible values are:
                  #     <valid IPv4 address> or empty string ("")
                  IPv4 = "";

                  # Use a specific IPv6 address for the Pi-hole host? See description for the IPv4
                  # variant above for further details.
                  force6 = false;

                  # Custom IPv6 address for the Pi-hole host
                  #
                  # Possible values are:
                  #     <valid IPv6 address> or empty string ("")
                  IPv6 = "";
                };

                blocking = {
                  # Use a specific IPv4 address in IP blocking mode? By default, FTL determines the
                  # address of the interface a query arrived on and uses this address for replying to A
                  # queries with the most suitable address for the requesting client. This setting can
                  # be used to use a fixed, rather than the dynamically obtained, address when Pi-hole
                  # responds in the following cases: IP blocking mode is used and this query is to be
                  # blocked, regular expressions with the ;reply=IP regex extension.
                  force4 = false;

                  # Custom IPv4 address for IP blocking mode
                  #
                  # Possible values are:
                  #     <valid IPv4 address> or empty string ("")
                  IPv4 = "";

                  # Use a specific IPv6 address in IP blocking mode? See description for the IPv4 variant
                  # above for further details.
                  force6 = false;

                  # Custom IPv6 address for IP blocking mode
                  #
                  # Possible values are:
                  #     <valid IPv6 address> or empty string ("")
                  IPv6 = "";
                };
              };

              rateLimit = {
                # Rate-limited queries are answered with a REFUSED reply and not further processed by
                # FTL.
                # The default settings for FTL's rate-limiting are to permit no more than 1000 queries
                # in 60 seconds. Both numbers can be customized independently. It is important to note
                # that rate-limiting is happening on a per-client basis. Other clients can continue to
                # use FTL while rate-limited clients are short-circuited at the same time.
                # For this setting, both numbers, the maximum number of queries within a given time,
                # and the length of the time interval (seconds) have to be specified. For instance, if
                # you want to set a rate limit of 1 query per hour, the option should look like
                # dns.rateLimit.count=1 and dns.rateLimit.interval=3600. The time interval is relative
                # to when FTL has finished starting (start of the daemon + possible delay by
                # DELAY_STARTUP) then it will advance in steps of the rate-limiting interval. If a
                # client reaches the maximum number of queries it will be blocked until the end of the
                # current interval. This will be logged to /var/log/pihole/FTL.log, e.g. Rate-limiting
                # 10.0.1.39 for at least 44 seconds. If the client continues to send queries while
                # being blocked already and this number of queries during the blocking exceeds the
                # limit the client will continue to be blocked until the end of the next interval
                # (FTL.log will contain lines like Still rate-limiting 10.0.1.39 as it made additional
                # 5007 queries). As soon as the client requests less than the set limit, it will be
                # unblocked (Ending rate-limitation of 10.0.1.39).
                # Rate-limiting may be disabled altogether by setting both values to zero (this
                # results in the same behavior as before FTL v5.7).
                # How many queries are permitted...
                count = 10000; ### CHANGED, default = 1000

                # ... in the set interval before rate-limiting?
                interval = 60;
              };
            };
            webserver = {
              # On which domain is the web interface served?
              #
              # Possible values are:
              #     <valid domain>
              domain = "localhost"; # Default pi.hole

              # Webserver access control list (ACL) allowing for restrictions to be put on the list
              # of IP addresses which have access to the web server. [...]
              #
              # Possible values are:
              #     <valid ACL>
              acl = "";

              # Ports to be used by the webserver.
              # [...]
              #
              # Possible values are:
              #     comma-separated list of <[ip_address:]port>
              port = "3334"; ### CHANGED (env), default = "80o,443os,[::]:80o,[::]:443os"

              # Maximum number of worker threads allowed.
              # The Pi-hole web server handles each incoming connection in a separate thread. [...]
              threads = 50;

              # Additional HTTP headers added to the web server responses.
              # [...]
              #
              # Possible values are:
              #     array of HTTP headers
              headers = [
                "X-DNS-Prefetch-Control: off"
                "Content-Security-Policy: default-src 'self' 'unsafe-inline';"
                "X-Frame-Options: DENY"
                "X-XSS-Protection: 0"
                "X-Content-Type-Options: nosniff"
                "Referrer-Policy: strict-origin-when-cross-origin"
              ];

              # Should the web server serve all files in webserver.paths.webroot directory? If
              # disabled, only files within the path defined through webserver.paths.webhome and
              # /api will be served.
              serve_all = false;

              session = {
                # Session timeout in seconds. If a session is inactive for more than this time, it will
                # be terminated. [...]
                timeout = 1800;

                # Should Pi-hole backup and restore sessions from the database? This is useful if you
                # want to keep your sessions after a restart of the web interface.
                restore = true;
              };

              #tls = {
                # Path to the TLS (SSL) certificate file. All directories along the path must be
                # readable and accessible by the user running FTL (typically 'pihole'). [...]
                #
                # Possible values are:
                #     <valid TLS certificate file (*.pem)>
                #cert = "/etc/pihole/tls.pem";
              #};

              #paths = {
                # Server root on the host
                #
                # Possible values are:
                #     <valid path>
                #webroot = "/var/www/html";

                # Sub-directory of the root containing the web interface
                #
                # Possible values are:
                #     <valid subpath>, both slashes are needed!
                #webhome = "/admin/";

                # Prefix where the web interface is served
                # [...]
                #
                # Possible values are:
                #     valid URL prefix or empty
                #prefix = "";
              #};

              interface = {
                # Should the web interface use the boxed layout?
                boxed = true;

                # Theme used by the Pi-hole web interface
                #
                # Possible values are:
                #   - "default-auto"
                #   - "default-light"
                #   - "default-dark"
                #   - "default-darker"
                #   - "high-contrast"
                #   - "high-contrast-dark"
                #   - "lcars"
                theme = "default-auto";
              };

              api = {
                # Number of concurrent sessions allowed for the API. If the number of sessions exceeds
                # this value, no new sessions will be allowed until the number of sessions drops due
                # to session expiration or logout. [...]
                max_sessions = 16;

                # Should FTL prettify the API output (add extra spaces, newlines and indentation)?
                prettyJSON = false;

                # API password hash
                #
                # Possible values are:
                #     <valid Pi-hole password hash>
                pwhash = "$BALLOON-SHA256$v=1$s=1024,t=32$7CJfup8/7jGX8lRwWmxkbA==$dr/bY6hyCSFAIxRUJOP6H45GEUa4M01rCvPytjP3jCU="; ### CHANGED, default = ""

                # Pi-hole 2FA TOTP secret. When set to something different than "", 2FA authentication
                # will be enforced for the API and the web interface. [...]
                #
                # Possible values are:
                #     <valid TOTP secret (20 Bytes in Base32 encoding)>
                totp_secret = "";

                # Pi-hole application password.
                # After you turn on two-factor (2FA) verification and set up an Authenticator app, you
                # may run into issues if you use apps or other services that don't support two-step
                # verification. [...]
                #
                # Possible values are:
                #     <valid Pi-hole password hash>
                app_pwhash = "";

                # Should application password API sessions be allowed to modify config settings?
                # Setting this to true allows third-party applications using the application password
                # to modify settings, e.g., the upstream DNS servers, DHCP server settings, or
                # changing passwords. [...]
                app_sudo = false;

                # Should FTL create a temporary CLI password? This password is stored in clear in
                # /etc/pihole and can be used by the CLI (pihole ...  commands) to authenticate
                # against the API. [...]
                cli_pw = true;

                # Array of clients to be excluded from certain API responses (regex):
                # - Query Log (/api/queries)
                # - Top Clients (/api/stats/top_clients)
                # [...]
                # Possible values are:
                #     array of regular expressions describing clients
                excludeClients = [];

                # Array of domains to be excluded from certain API responses (regex):
                # - Query Log (/api/queries)
                # - Top Clients (/api/stats/top_domains)
                # Note that backslashes "\" need to be escaped, i.e. "\\" in this setting
                #
                # Example: [ "(^|\\.)\\.google\\.de$", "\\.pi-hole\\.net$" ]
                #
                # Possible values are:
                #     array of regular expressions describing domains
                excludeDomains = [];

                # How much history should be imported from the database and returned by the API
                # [seconds]? (max 24*60*60 = 86400)
                maxHistory = 86400;

                # Up to how many clients should be returned in the activity graph endpoint
                # (/api/history/clients)? [...]
                maxClients = 10;

                # How should the API compute the most active clients? If set to true, the API will
                # return the clients with the most queries globally (within 24 hours). [...]
                client_history_global_max = true;

                # Allow destructive API calls (e.g. restart DNS server, flush logs, ...)
                allow_destructive = true;

                temp = {
                  # Which upper temperature limit should be used by Pi-hole? Temperatures above this
                  # limit will be shown as "hot". The number specified here is in the unit defined below
                  limit = 60.000000;

                  # Which temperature unit should be used for temperatures processed by FTL?
                  #
                  # Possible values are:
                  #   - "C"
                  #   - "F"
                  #   - "K"
                  unit = "C";
                };
              };
            };
          };
        };

        pihole-web = {
          enable = true;
          ports = [
            "3334"
          ];
          hostName = "localhost";
        };
      };

    services.nginx = {
      virtualHosts = {
        "pihole.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3334";
          };
        };
      };
    };
  };
}

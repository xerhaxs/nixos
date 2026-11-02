{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.hardening;
in

{
  options.nixos = {
    system.hardening = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable basic system hardening.";
      };

      ptraceScope = lib.mkOption {
        type = lib.types.ints.between 0 3;
        default = 1;
        example = 0;
        description = "kernel.yama.ptrace_scope (1 = only parent processes or root may attach).";
      };

      kernelParams = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Memory hardening kernel parameters (init_on_free, slab_nomerge, ...).";
      };

      blacklistModules = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Prevent loading of rarely used network protocols and filesystems (udf stays allowed on desktops).";
      };

      hidepid = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Mount /proc with hidepid=2, users only see their own processes.";
      };

      unitHardening = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        readOnly = true;
        default = {
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          SystemCallArchitectures = "native";
        };
        description = "Common systemd hardening for the own units (serviceConfig = unitHardening // { ... }).";
      };

      audit = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable auditd with rules for identity, sudo, ssh, kernel modules and root commands of users.";
      };

      auditExec = lib.mkOption {
        type = lib.types.bool;
        default = !config.nixos.desktop.enable;
        defaultText = lib.literalExpression "!config.nixos.desktop.enable";
        description = "Log every program execution (execve) with auditd and forward audit records to the journal (Loki alert for user commands outside /nix/store). Logs are rotated (5 x 50 MB).";
      };

      server = lib.mkOption {
        type = lib.types.bool;
        default = !config.nixos.desktop.enable;
        defaultText = lib.literalExpression "!config.nixos.desktop.enable";
        description = "Server hardening: more ASLR entropy, panic and reboot on kernel oops, disable geoclue, ModemManager and avahi (unless a module enables it).";
      };

      hardenedMalloc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Use graphene-hardened-light as memory allocator for all programs (preloaded globally, test services first).";
      };

      ntsTime = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use chrony with authenticated time (NTS) instead of systemd-timesyncd. Unauthenticated pool servers are only used when they agree with the NTS servers.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.sudo.execWheelOnly = true;

    security.wrappers = {
      su.enable = lib.mkForce false;
      sg.enable = lib.mkForce false;
      newgrp.enable = lib.mkForce false;
      sudoedit.enable = lib.mkForce false;
    };

    environment.defaultPackages = lib.mkForce [ ];

    environment.systemPackages = with pkgs; [
      kernel-hardening-checker
      lynis
    ];

    nix.settings.allowed-users = [
      "root"
      "@wheel"
    ];

    security.protectKernelImage = true;

    boot.kernel.sysctl = {
      # kernel
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
      "kernel.yama.ptrace_scope" = config.nixos.system.hardening.ptraceScope;
      "fs.suid_dumpable" = 0;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "dev.tty.ldisc_autoload" = 0;
      "vm.unprivileged_userfaultfd" = 0;

      # network
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
    }
    // lib.optionalAttrs cfg.server {
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
      "kernel.panic" = 10;
    };

    boot.kernelParams =
      lib.optionals cfg.kernelParams [
        "init_on_alloc=1"
        "init_on_free=1"
        "slab_nomerge"
        "page_alloc.shuffle=1"
        "randomize_kstack_offset=on"
        "vsyscall=none"
        "debugfs=off"
        "pti=on"
      ]
      ++ lib.optional cfg.audit "audit=1"
      ++ lib.optional cfg.server "oops=panic";

    boot.extraModprobeConfig = lib.mkIf cfg.blacklistModules (
      lib.concatMapStrings (module: "install ${module} ${pkgs.coreutils}/bin/false\n") (
        [
          "dccp"
          "sctp"
          "rds"
          "tipc"
          "cramfs"
          "freevxfs"
          "jffs2"
          "hfs"
          "hfsplus"
        ]
        ++ lib.optional (!config.nixos.desktop.enable) "udf"
      )
    );

    boot.specialFileSystems."/proc".options = lib.mkIf cfg.hidepid [
      "hidepid=2"
      "gid=${toString config.ids.gids.proc}"
    ];
    users.groups.proc.gid = lib.mkIf cfg.hidepid config.ids.gids.proc;
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups = lib.mkIf cfg.hidepid [ "proc" ];
    systemd.services.polkit.serviceConfig.SupplementaryGroups = lib.mkIf cfg.hidepid [ "proc" ];

    security.auditd.enable = cfg.audit;
    security.audit = lib.mkIf cfg.audit {
      enable = true;
      # The default of 1024 overflows during boot, before auditd consumes the queue.
      backlogLimit = 8192;
      rules = [
        "-w /etc/passwd -p wa -k identity"
        "-w /etc/shadow -p wa -k identity"
        "-w /etc/group -p wa -k identity"
        "-w /etc/sudoers -p wa -k sudoers"
        "-w /etc/ssh/sshd_config -p wa -k sshd"
        "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k modules"
        "-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=4294967295 -k root-commands"
      ]
      ++ lib.optionals cfg.auditExec [
        "-a always,exit -F arch=b64 -S execve,execveat -k exec"
        "-a always,exit -F arch=b32 -S execve,execveat -k exec"
      ];
    };

    security.auditd.settings = lib.mkIf cfg.audit {
      max_log_file = 50;
      num_logs = 5;
      max_log_file_action = "rotate";
    };

    services.journald.settings.Journal.Audit = lib.mkIf cfg.auditExec true;

    security.sudo.extraConfig = ''
      Defaults log_allowed, log_denied
    '';

    systemd.coredump.settings.Coredump = {
      MaxUse = "512M";
      ProcessSizeMax = "512M";
      ExternalSizeMax = "512M";
    };

    services.journald.settings.Journal = {
      SystemMaxUse = "1G";
      MaxRetentionSec = "3month";
    };

    environment.memoryAllocator.provider = lib.mkIf cfg.hardenedMalloc "graphene-hardened-light";

    services.chrony = lib.mkIf cfg.ntsTime {
      enable = true;
      enableNTS = true;
      servers = [
        "ptbtime1.ptb.de"
        "ptbtime2.ptb.de"
        "ptbtime3.ptb.de"
        "nts.netnod.se"
        "time.cloudflare.com"
      ];
      extraConfig = ''
        pool 2.nixos.pool.ntp.org iburst maxsources 2
        authselectmode mix
        nocerttimecheck 1
      '';
    };

    services.geoclue2.enable = lib.mkIf cfg.server (lib.mkDefault false);
    networking.modemmanager.enable = lib.mkIf cfg.server (lib.mkForce false);
    services.avahi.enable = lib.mkIf cfg.server (lib.mkDefault false);

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = lib.optional cfg.ntsTime {
        directory = "/var/lib/chrony";
        user = "chrony";
        group = "chrony";
        mode = "0750";
      };
    };
  };
}

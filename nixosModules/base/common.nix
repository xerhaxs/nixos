{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    base.common = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable common tools.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.common.enable {
    environment.systemPackages =
      with pkgs;
      [
        # fetchers
        fastfetch
        cpufetch
        ipfetch

        ranger
        p7zip
        unrar
        unzip
        zip
        xz
        zstd
        rsync
        file
        tree
        glow

        # disks
        parted
        gptfdisk
        testdisk
        fwupd

        # network
        inetutils
        dnsutils
        ldns
        ipcalc
        iperf3
        iftop
        tcpdump
        mtr
        nmap
        openssl
        socat
        ethtool

        # system
        htop
        iotop
        lsof
        strace
        sysstat
        lm_sensors
        pciutils
        usbutils
        usbtop
        clinfo
        mesa-demos
        killall
        jq
        gawk
        gnused
        gnutar
        which
        gnupg

        # fun
        cmatrix
        hollywood
        asciiquarium
        cowsay
      ]
      ++ lib.optionals config.nixos.desktop.enable [
        gparted
        imagemagick
        ntfs3g
      ];
  };
}

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
    environment.systemPackages = with pkgs; [
      # fetchers
      fastfetch
      cpufetch

      # terminal file manager
      ranger

      # archives
      cdrkit
      p7zip
      unrar
      unzip
      xz
      zip
      zstd

      # utils
      parted
      gparted
      gptfdisk
      jq # A lightweight and flexible command-line JSON processor
      killall
      putty
      wget
      testdisk

      clinfo
      fwupd
      mesa-demos
      imagemagick
      rsync

      # networking tools
      inetutils
      dnsutils # `dig` + `nslookup`
      ipcalc # it is a calculator for the IPv4/v6 addresses
      iperf3
      ipfetch
      iftop # network monitoring
      iotop # io monitoring
      tcpdump
      ldns # replacement of `dig`, it provide the command `drill`
      mtr # A network diagnostic tool
      nmap # A utility for network discovery and security auditing
      openssl
      socat # replacement of openbsd-netcat

      # misc
      cmake
      php
      file
      gawk
      gnupg
      gnused
      gnutar
      tree
      which

      # productivity
      glow # markdown previewer in terminal
      hugo # static site generator

      # system call monitoring
      lsof # list open files
      ltrace # library call monitoring
      strace # system call monitoring

      # system tools
      ethtool
      htop
      lm_sensors # for `sensors` command
      ntfs3g # for ntfs file systems
      pciutils # lspci
      sbctl # secure boot
      sysstat
      usbtop
      usbutils # lsusb

      # fun tools
      cmatrix # matrix prompt for the terminal
      hollywood # hollywood hacking prompt for the terminal
      asciiquarium # aquarium in the terminal
      cowsay # generates ASCII art pictures of a cow
    ];
  };
}

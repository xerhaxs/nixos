{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.common = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable common tools.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.common.enable {
    environment.systemPackages = with pkgs; [
      # fetchers
      neofetch
      cpufetch
      
      # terminal file manager
      ranger

      # archives
      cdrkit
      p7zip
      rarcrack # cracking .zip files
      unrar
      unzip
      xz
      zip
      zstd

      # utils
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      pv # replacement of cp
      parted
      gparted
      gptfdisk
      jq # A lightweight and flexible command-line JSON processor
      killall
      putty
      ripgrep # recursively searches directories for a regex pattern
      wget
      yq-go # yaml processer https://github.com/mikefarah/yq
      testdisk

      clinfo
      fwupd
      mesa-demos
      imagemagick
      lv
      rsync

      # networking tools
      inetutils
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      dnsutils  # `dig` + `nslookup`
      ipcalc  # it is a calculator for the IPv4/v6 addresses
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
      newt # whiptail package for nixos
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
      lm_sensors # for `sensors` command
      ntfs3g # for ntfs file systems
      pciutils # lspci
      sysstat
      usbutils # lsusb

      # fun tools
      cmatrix # matrix prompt for the terminal
      hollywood # hollywood hacking prompt for the terminal
      asciiquarium # aquarium in the terminal
      cowsay # generates ASCII art pictures of a cow 
    ];
  };
}
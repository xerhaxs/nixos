{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Standard
    qalculate-gtk
    keepassxc
    protonmail-bridge

    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    neofetch
    cpufetch
    ranger # terminal file manager

    # archives
    zip
    xz
    unzip
    unrar
    p7zip
    cdrkit

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    putty
    inetutils
    killall

    imagemagick
    poppler_utils
    ventoy
    partition-manager
    vcftools
    rsync
    fwupd
    glxinfo
    vulkan-tools
    clinfo
    lv
    wlr-randr
    wayland-utils

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    ipfetch
    openssl

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    parted
    cmake

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    pv # replacement of cp
    iotop # io monitoring
    iftop # network monitoring
    #nvtop # nvidia monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    powerstat
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # fun tools
    cmatrix # matrix prompt for the terminal
    hollywood # hollywood hacking prompt for the terminal
  ];
}

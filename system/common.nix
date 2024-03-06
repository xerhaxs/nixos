{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable binary support for flakes
  programs.nix-ld.enable = true;

  #services.ratbagd.enable = true;

  # Automatic system update
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-unstable";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      sandbox = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    newt # whiptail package for nixos
    gparted
    sbctl # for secureboot
    ntfs3g # support for windows file systems
    nix-output-monitor # nix related
    nix-prefetch
    nixos-generators
    #home-manager.packages."${pkgs.system}".home-manager
  ];

  programs.vim.defaultEditor = true;
  programs.htop.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

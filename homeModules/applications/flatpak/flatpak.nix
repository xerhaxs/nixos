{ config, flatpaks, lib, pkgs, ... }:

{
  imports = [
    flatpaks.homeManagerModules.declarative-flatpak
  ];

  options.homeManager = {
    applications.flatpak.flatpak = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable flatpak.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.flatpak.flatpak.enable {
    services.flatpak = {
      deduplicate = true;
      #recycle-generation = false;
      #update = {
      #  auto.enable = true;
      #  onActivation = true;
      #  onCalendar = "weekly";
      #};

      remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      };
      
      packages = [
        "flathub:app/com.github.tchx84.Flatseal//stable"
      ];

      overrides = {
        #"global" = {
          #filesystems = [
          #  "home"
          #  "!~/Games/Heroic"
          #];
          #environment = {
          #  "MOZ_ENABLE_WAYLAND" = 1;
          #};
          #sockets = [
          #  "!x11"
          #  "fallback-x11"
          #];
        #};
      };
    };
  };
}
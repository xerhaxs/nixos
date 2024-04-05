{ config, pkgs, flatpak, ... }:

{
  services.flatpak = {
    enable = true;
    deduplicate = true;
    recycle-generation = false;
    update = {
      auto.enable = true;
      onActivation = true;
      onCalendar = "weekly";
    };

    remotes = {
     "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
    };
    
    packages = [
      "com.github.tchx84.Flatseal"
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
}
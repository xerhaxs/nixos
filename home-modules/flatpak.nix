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
    packages = [
      "com.github.tchx84.Flatseal"
      "com.discordapp.Discord"
      "com.valvesoftware.Steam"
      "com.heroicgameslauncher.hgl"
      "org.prismlauncher.PrismLauncher"
      "net.lutris.Lutris"
      "org.freedesktop.Platform.VulkanLayer.MangoHud"
    ];
    remotes = {
     "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
    };
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
    preSwitchCommand = [
      "com.valvesoftware.Steam:flatpak override --user --filesystem=/mount/Games/Spiele/Steam/ com.valvesoftware.Steam"
    ];
  };
}
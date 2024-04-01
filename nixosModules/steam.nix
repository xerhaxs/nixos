{ config, pkgs, ... }:

{
  systemd.user.services.sirmorton = {
    script = ''
      flatpak run com.valvesoftware.Steam
     '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };
}

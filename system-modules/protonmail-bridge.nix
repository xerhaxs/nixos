{ config, pkgs, ... }:

{
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    protonmail-bridge
    #home-manager.packages."${pkgs.system}".home-manager
  ];

  systemd.user.services.jf = {
    script = ''
      protonmail-bridge -n
     '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };
}

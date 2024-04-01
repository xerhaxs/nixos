{ config, pkgs, ... }:

{
  systemd.services.pufferpanel.serviceConfig.EnvironmentFile = [ 
    config.sops.secrets."pufferpanel/users/admin/email".path
    config.sops.secrets."pufferpanel/users/admin/password".path 
  ];

  environment.systemPackages = with pkgs; [
    pufferpanel
  ];

  # setup admin account: "pufferpanel user add" 

  services.pufferpanel = {
    enable = true;
    
    environment = {
      PUFFER_WEB_HOST = ":9090";
      PUFFER_DAEMON_SFTP_HOST = ":5657";
      PUFFER_DAEMON_CONSOLE_BUFFER = "1000";
      PUFFER_DAEMON_CONSOLE_FORWARD = "true";
      PUFFER_PANEL_REGISTRATIONENABLED = "false";
      EMAILUSERNAME = "{env}ENV_EMAIL";
      EMAILPASSWORD = "{env}ENV_PASSWORD";
    };

    extraPackages = with pkgs; [
      jre
    ];
  };
}

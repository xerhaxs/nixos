  { config, pkgs, ... }:

{
  services.libreddit = {
    enable = true;
    address = "127.0.0.1";
    port = 8975;
    openFirewall = false;
  };
}

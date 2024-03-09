{ config, pkgs, ... }:


{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/master/nixos-mailserver-master.tar.gz";
      sha256 = "sha256:0zwpqrd5znba7av2xsk9c8qyhxnad69abbsqg7m4l3yy4hhwrzxj";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.bitsync.icu";
    domains = [ "bitsync.icu" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "example@mail.com" = {
        hashedPasswordFile = "EXAMPLE-PASSWORD.txt";
        aliases = [ "example-alias@mail.com" ];
      };
      "example2@mail.com" = {
        hashedPasswordFile = "EXAMPLE2-PASSWORD.txt";
        aliases = [ "example-alias@mail.com" ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
}
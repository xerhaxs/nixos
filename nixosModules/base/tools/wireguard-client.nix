{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.tools.wireguard-client = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Wireguard VPN Client.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.tools.wireguard-client.enable {
    #environment.systemPackages = with pkgs; [
    #  wireguard-tools
    #];

    networking = {
      firewall.allowedUDPPorts = [ 59595 ];

      wireguard.interfaces = {
        # "wg0" is the network interface name. You can name the interface arbitrarily.
        NixOS-Laptop = {
          # Determines the IP address and subnet of the client's end of the tunnel interface.
          ips = [ "10.75.0.202/24" ];
          listenPort = 59595; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
          privateKeyFile = config.sops.secrets."wireguard/home/privateKey".path;;
          # Path to the private key file.
          #
          # Note: The private key can also be included inline via the privateKey option,
          # but this makes the private key world-readable; thus, using privateKeyFile is
          # recommended.
          #privateKeyFile = "path to private key file";

          #generatePrivateKeyFile = true;

          peers = [
            # For a client configuration, one peer entry for the server will suffice.

            {
              # Public key of the server (not a file path).
              publicKey = "6GGSgE9rSqH4gwDEgnmzCmbkcVrkclWqrvkoaghwlG8=";

              presharedKeyFile = config.sops.secrets."wireguard/home/presharedKey".path;

              # Forward all the traffic via VPN.
              allowedIPs = [ "10.75.0.0/24" "0.0.0.0/0" ];
              # Or forward only particular subnets
              #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

              # Set this to the server IP and port.
              endpoint = "o0p28wg8dxwtcewi.myfritz.net:59595"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

              # Send keepalives every 25 seconds. Important to keep NAT tables alive.
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}

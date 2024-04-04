{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.kdeconnect = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable kdeconnect.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.kdeconnect.enable {
    programs.kdeconnect.enable = true;
    networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };
  };
}


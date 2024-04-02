{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    userEnvironment.kdeconnect = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable kdeconnect.";
      };
    };
  };

  config = mkIf config.nixos.userEnvironment.kdeconnect.enable {
    programs.kdeconnect.enable = true;
    networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };
  };
}


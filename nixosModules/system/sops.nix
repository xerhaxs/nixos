{
  config,
  lib,
  pkgs,
  private,
  sops-nix,
  userName,
  ...
}:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  options.nixos = {
    system.sops = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Sops.";
      };

      file = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "nixos-serverpublic";
        description = "Secrets file of the host in the private repository (secrets/<file>.yaml), only this file is copied to the host. Required when sops is enabled.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.sops.enable {
    assertions = [
      {
        assertion = config.nixos.system.sops.file != null;
        message = "nixos.system.sops.file is not set: name the secrets file of this host in the private repository (secrets/<file>.yaml).";
      }
    ];

    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      # builtins.path copies only this file. "${private}/..." would put the whole private repository
      # (all sops files, site.nix with the password hashes of every host) on the host.
      defaultSopsFile = lib.mkIf (config.nixos.system.sops.file != null) (
        builtins.path {
          path = "${private}/secrets/${config.nixos.system.sops.file}.yaml";
          name = "${config.nixos.system.sops.file}.yaml";
        }
      );
      defaultSopsFormat = "yaml";
      age.keyFile = lib.mkDefault "/secrets/keys.txt";

      secrets = lib.mkIf config.nixos.userEnvironment.enable {
        "alphavantage/api_key" = {
          owner = config.users.users.${userName}.name;
          group = config.users.users.${userName}.group;
          mode = "0440";
        };

        # Read by the calendar sync of the desktop, the Radicale module of a server sets its own owner.
        "radicale/htpasswd" = {
          owner = lib.mkDefault config.users.users.${userName}.name;
          group = lib.mkDefault config.users.users.${userName}.group;
          mode = lib.mkDefault "0440";
        };

        "weather-location" = {
          owner = config.users.users.${userName}.name;
          group = config.users.users.${userName}.group;
          mode = "0440";
        };

        "mullvad" = {
          owner = config.users.users.${userName}.name;
          group = config.users.users.${userName}.group;
          mode = "0440";
        };
      };
    };
  };
}

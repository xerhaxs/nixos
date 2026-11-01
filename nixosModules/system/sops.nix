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

      perHostFile = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Use the own secrets file of the host from the private repository (secrets/<hostname>.yaml).";
      };
    };
  };

  config = lib.mkIf config.nixos.system.sops.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      defaultSopsFile =
        if config.nixos.system.sops.perHostFile then
          "${private}/secrets/${lib.toLower config.networking.hostName}.yaml"
        else
          ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      #age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.keyFile = lib.mkDefault "/secrets/keys.txt";

      secrets = lib.mkIf config.nixos.userEnvironment.enable {
        "alphavantage/api_key" = {
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

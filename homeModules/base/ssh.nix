{
  config,
  lib,
  pkgs,
  osConfig,
  userName,
  ...
}:

{
  options.homeManager = {
    base.ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable ssh.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.ssh.enable {
    # The servers allow 3 authentication attempts, offer only the own key there (the private key may
    # live in the KeePassXC agent, the public key file is enough).
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "NixOS-Server1 NixOS-ServerPublic 10.100.0.*" = lib.hm.dag.entryBefore [ "*" ] {
          IdentitiesOnly = "yes";
          IdentityFile = "~/.ssh/id_ed25519.pub";
        };
        "*" = {
          AddKeysToAgent = "no";
          HashKnownHosts = "yes";
          ServerAliveInterval = 60;
        };
      };
    };
  };
}

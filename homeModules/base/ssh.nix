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
    # The public key of this host comes from the authorized keys of the servers (comment
    # <user>@<host>), so ssh finds it after a reinstall while the private key stays in KeePassXC.
    # force replaces the file created by ssh-keygen once.
    home.file.".ssh/id_ed25519.pub" =
      let
        ownKey = lib.findFirst (
          key: lib.hasSuffix " ${userName}@${osConfig.networking.hostName}" key
        ) null osConfig.nixos.system.ssh.authorizedKeys;
      in
      lib.mkIf (ownKey != null) {
        text = ownKey + "\n";
        force = true;
      };

    # The servers allow 3 authentication attempts, offer only the own key there. Without .pub this works
    # with the key in the KeePassXC agent and, while the agent is empty, with the file. ssh finds the
    # public key next to it, the private key file may be missing. A path to the .pub only works with
    # the agent, otherwise ssh tries to load it as a private key.
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "NixOS-Server1 NixOS-ServerGaming NixOS-ServerPublic 10.100.0.*" = lib.hm.dag.entryBefore [ "*" ] {
          IdentitiesOnly = "yes";
          IdentityFile = "~/.ssh/id_ed25519";
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

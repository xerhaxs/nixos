{
  config,
  lib,
  impermanence,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.shell.bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable bash.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.bash.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';

      shellAliases = {
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      files = [
        ".bash_history"
      ];
    };
  };
}

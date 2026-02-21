{
  config,
  lib,
  impermanence,
  pkgs,
  ...
}:

{
  home.persistence."/persistent" = {
/*     directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ]; */
    files = [
      ".bash_history"
      ".viminfo"
    ];
  };
}

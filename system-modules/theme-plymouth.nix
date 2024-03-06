{ config, libs, pkgs, ... }:

let
  plymouth = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "master"; # commit hash or tag
    sha256 = ""; #sha256 = lib.fakeSha256;
  };
  theme = "pack_3/hud_3";
in

{
  boot.plymouth = {
    #themePackages = [];
    theme = pkgs.lib.mkDefault (plymouth + "/${theme}");
  };
}

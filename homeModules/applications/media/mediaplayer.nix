{ config, lib, pkgs, ... }:

let
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
  };
  myVlc = pkgs.vlc.override { inherit libbluray; };
in

{
  options.homeManager = {
    applications.media.mediaplayer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mediaplayer.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.mediaplayer.enable {
    home.packages = with pkgs; [
      clementine
      myVlc
    ];

    programs.java = {
      enable = true;
      package = lib.mkForce pkgs.jdk17;
    };
  };
}



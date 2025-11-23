{ config, lib, pkgs, ... }:

let
  keydbUrl = "http://fvonline-db.bplaced.net/fv_download.php?lang=deu";
in

{
  options.homeManager = {
    applications.editing.compiler = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Media compiler tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.compiler.enable {
    home.packages = with pkgs; [
      gst_all_1.gst-libav
      handbrake
      makemkv
    ];

    home.file.".config/aacs/KEYDB.cfg".text = builtins.toString (pkgs.runCommand "keydb" {} ''
      mkdir -p $out
      ${pkgs.curl}/bin/curl -L -o keydb.zip ${keydbUrl}
      ${pkgs.unzip}/bin/unzip -p keydb.zip keydb.cfg > $out/KEYDB.cfg
    '');
  };
}
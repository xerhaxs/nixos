{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.easyeffects = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable easyeffects";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.easyeffects.enable {
    home.packages = with pkgs; [
      crosspipe
    ];

    services.easyeffects = {
      enable = false;
      package = pkgs.easyeffects;
      #preset = "";
      extraPresets = {
        my-preset = {
          input = {
            blocklist = [ ];
            "plugins_order" = [
              "rnnoise#0"
            ];
            "rnnoise#0" = {
              bypass = false;
              "enable-vad" = false;
              "input-gain" = 0.0;
              "model-path" = "";
              "output-gain" = 0.0;
              release = 20.0;
              "vad-thres" = 50.0;
              wet = 0.0;
            };
          };
        };
      };
    };
  };
}

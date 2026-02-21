{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.vpn.mullvad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mullvad.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.vpn.mullvad.enable {
    home.packages = with pkgs; [
      mullvad-browser
      mullvad-vpn
    ];
  };
}

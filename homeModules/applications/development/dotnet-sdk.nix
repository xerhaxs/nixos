{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development.dotnet-sdk = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dotnet-sdk.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.dotnet-sdk.enable {
    home.package = with pkgs; [
      dotnet-sdk
    ]
  };
}

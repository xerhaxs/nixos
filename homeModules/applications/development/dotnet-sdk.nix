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
    home.packages = with pkgs; [
      #msbuild
      dotnet-sdk
      #monoDLLFixer
      icu
      mono
    ];
  };
}

{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.shell.starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable starship.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.starship.enable {
    programs.starship = 
      let
          flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
      in 
    {   
      enable = true;
        
      enableBashIntegration = true;

      #settings = {
      #  # Other config here
      #  format = "$all"; # Remove this line to disable the default prompt format
      #  palette = "catppuccin_${flavour}";
      #} // builtins.fromTOML (builtins.readFile
      #  (pkgs.fetchFromGitHub {
      #    owner = "catppuccin";
      #    repo = "starship";
      #    rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f"; # Replace with the latest commit hash
      #    sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
      #} + /palettes/${flavour}.toml));  
    };
  };
}
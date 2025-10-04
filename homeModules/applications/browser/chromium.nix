{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.browser.chromium = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Chromium browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.brave.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      dictionaries = with pkgs; [
        hunspellDictsChromium.de_DE
        hunspellDictsChromium.en_US
      ];
      extensions = [
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "fnaicdffflnofjppbagibeoednhnbjhg"; } # Floccus Bookmark Sync
        { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # I still don't care about cookies
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC
        { id = "dphilobhebphkdjbpfohgikllaljmgbn"; } # SimpleLogin
        { id = "mafpmfcccpbjnhfhjnllmmalhifmlcie"; } # Snowflake
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      ];
    };
  };
}